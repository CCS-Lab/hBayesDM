#!/usr/bin/env python3
"""
Generate R codes for hBayesDM using model information defined in a JSON file.
"""
import sys
import argparse
import json
import re
from pathlib import Path
from typing import List, Iterable, Callable
from collections import OrderedDict

PATH_ROOT = Path(__file__).absolute().parent
PATH_MODELS = PATH_ROOT / 'models'
PATH_TEMPLATE = PATH_ROOT / 'templates'
PATH_OUTPUT = PATH_ROOT / 'R'

TEMPLATE_DOCS = PATH_TEMPLATE / 'R_DOCS_TEMPLATE.txt'
TEMPLATE_CODE = PATH_TEMPLATE / 'R_CODE_TEMPLATE.txt'


def parse_cite_string(cite):
    """Parse given APA citation string into a dict object"""
    if cite == '':
        return None

    regex_authoryear = r'(?P<authors>^.+?)\s\((?P<year>\d+?)\)'
    regex_author = r'(?=\s\&)?\s?(?P<author>[^,&]+?,\s[^,&]+?)(?=,|\n|\r|$)'

    m_ay = re.search(regex_authoryear, cite)
    year = m_ay.group('year')

    authors = []
    for m in re.finditer(regex_author, m_ay.group('authors')):
        authors.append(m.group('author'))

    firstauthor = authors[0].split(',')[0]
    shortcite = '{}{}'.format(firstauthor, year)
    if len(authors) == 1:
        barecite = '{}, {}'.format(firstauthor, year)
        textcite = '{} ({})'.format(firstauthor, year)
    else:
        barecite = '{} et al., {}'.format(firstauthor, year)
        textcite = '{} et al. ({})'.format(firstauthor, year)
    parencite = '({})'.format(barecite)

    return {
        'authors': authors,
        'year': year,
        'shortcite': shortcite,
        'barecite': barecite,
        'fullcite': cite
    }


def format_parencite(cites):
    if len(cites) == 0:
        return ''
    return '(' + '; '.join([c['barecite'] for c in cites if c]) + ')'


def format_fullcite(cites, sep='\n#\' '):
    if len(cites) == 0:
        return ''
    return sep.join([c['fullcite'] for c in cites if c])


def generate_docstring(info):
    # Model full name (Snake-case)
    model_function = [info['task_name']['code'], info['model_name']['code']]
    if info['model_type']['code'] != '':
        model_function.append(info['model_type']['code'])
    model_function = '_'.join(model_function)

    # Citations
    task_cite = [parse_cite_string(c) for c in info['task_name']['cite']]
    model_cite = [parse_cite_string(c) for c in info['model_name']['cite']]

    task_parencite = format_parencite(task_cite)
    model_parencite = format_parencite(model_cite)

    references = format_fullcite(task_cite + model_cite, sep='\n#\'\n#\' ')

    # Notes
    if len(info.get('notes', [])) > 0:
        notes = '@note\n#\' \\strong{Notes:}\n#\' ' + \
                '\n#\' '.join(info['notes'])
        notes = '\n#\' ' + notes + '\n#\''
    else:
        notes = ''

    # Contributors
    contributors = ', '.join([
        r'\href{%s}{%s} <\email{%s}>'
        % (c['link'], c['name'], c['email'].replace('@', '@@'))
        for c in info.get('contributors', [])
    ])

    # Data columns
    data_columns = ', '.join([
        r'"%s"' % k for k in info.get('data_columns', {}).keys()
    ])
    data_columns_len = len(info['data_columns'])
    data_columns_details = '\n#\' '.join([
        r'@templateVar DETAILS_DATA_%d \item{%s}{%s}'
        % (i + 1, k, v.replace('\n', '\\cr'))
        for i, (k, v) in enumerate(info['data_columns'].items())
    ])

    # Parameters
    parameters = ', '.join([
        '\\code{%s} (%s)' % (k, v['desc'])
        for k, v in info['parameters'].items()
    ])

    # Regressors
    regressors = ', '.join([
        '"%s"' % k for k in info.get('regressors', {}).keys()
    ])

    # Postpreds
    postpreds = ', '.join([
        '"%s"' % v for v in info.get('postpreds', [])
    ])

    # Additional arguments
    additional_args = info.get('additional_args', {})
    additional_args_len = len(additional_args)
    if additional_args_len > 0:
        additional_args_details = '\n#\' '.join([
            r'@templateVar ADDITIONAL_ARGS_%d \item{%s}{%s}'
            % (i + 1, v['code'], v['desc'])
            for i, v in enumerate(additional_args)
        ])
        additional_args_details += '\n#\''
    else:
        additional_args_details = ''

    # Read template for docstring
    with open(TEMPLATE_DOCS, 'r') as f:
        docs_template = f.read()

    docs = docs_template % dict(
        model_function=model_function,
        task_name=info['task_name']['desc'],
        task_code=info['task_name']['code'],
        task_parencite=task_parencite,
        model_name=info['model_name']['desc'],
        model_code=info['model_name']['code'],
        model_parencite=model_parencite,
        model_type=info['model_type']['desc'],
        notes=notes,
        contributor=contributors,
        data_columns=data_columns,
        data_columns_len=data_columns_len,
        data_columns_details=data_columns_details,
        parameters=parameters,
        regressors=regressors,
        postpreds=postpreds,
        additional_args_len=additional_args_len,
        additional_args_details=additional_args_details,
        references=references,
    )

    return docs


def generate_code(info):
    # Model full name (Snake-case)
    model_function = [info['task_name']['code'], info['model_name']['code']]
    if info['model_type']['code'] != '':
        model_function.append(info['model_type']['code'])
    model_function = '_'.join(model_function)

    # Prefix to preprocess_func
    prefix_preprocess_func = info['task_name']['code']
    if info['model_type']['code']:
        prefix_preprocess_func += '_' + info['model_type']['code']
    preprocess_func = prefix_preprocess_func + '_preprocess_func'

    # Data columns
    data_columns = ', '.join([
        r'"%s"' % k for k in info.get('data_columns', {}).keys()
    ])

    # Parameters
    _params = info.get('parameters', {})
    if len(_params) > 0:
        parameters = ',\n    '.join([
            '"{}" = c({}, {}, {})'
            .format(k,
                    v['info'][0] if v['info'][0] else 'NULL',
                    v['info'][1] if v['info'][1] else 'NULL',
                    v['info'][2] if v['info'][2] else 'NULL')
            for k, v in _params.items()
        ])
        parameters = 'list(\n    ' + parameters + '\n  )'
    else:
        parameters = 'NULL'

    # Regressors
    _regs = info.get('regressors', {})
    if len(_regs) > 0:
        regressors = ',\n    '.join([
            '"{}" = {}'.format(k, v) for k, v in _regs.items()
        ])
        regressors = 'list(\n    ' + regressors + '\n  )'
    else:
        regressors = 'NULL'

    # Postpreds
    _postpreds = info.get('postpreds', [])
    if len(_postpreds) > 0:
        postpreds = ', '.join(['"%s"' % v for v in _postpreds])
        postpreds = 'c(' + postpreds + ')'
    else:
        postpreds = 'NULL'

    # Read template for model codes
    with open(TEMPLATE_CODE, 'r') as f:
        code_template = f.read()

    code = code_template % dict(
        model_function=model_function,
        task_code=info['task_name']['code'],
        model_code=info['model_name']['code'],
        model_type=info['model_type']['code'],
        data_columns=data_columns,
        parameters=parameters,
        regressors=regressors,
        postpreds=postpreds,
        preprocess_func=preprocess_func,
    )

    return code


def main(json_fn, verbose):
    with Path(json_fn) as p:
        # Check if file exists
        if not p.exists():
            print('FileNotFound: Please specify existing json_file as argument.')
            sys.exit(1)

        # Load json_file
        with open(p, 'r') as f:
            info = model_info = json.load(f, object_pairs_hook=OrderedDict)

    docs = generate_docstring(info)
    code = generate_code(info)
    output = docs + code

    if verbose:
        # Print code string to stdout
        print(output)
    else:
        # Model full name (Snake-case)
        model_function = [info['task_name']
                          ['code'], info['model_name']['code']]
        if info['model_type']['code'] != '':
            model_function.append(info['model_type']['code'])
        model_function = '_'.join(model_function)

        if not PATH_OUTPUT.exists():
            PATH_OUTPUT.mkdir(exist_ok=True)

        # Write model python code
        code_fn = PATH_OUTPUT / (model_function + '.R')
        with open(code_fn, 'w') as f:
            f.write(output)
        print('Created file:', code_fn.name)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-a', '--all',
        help='write for all json files in directory',
        action='store_true')
    parser.add_argument(
        '-v', '--verbose',
        help='print output to stdout instead of writing to file',
        action='store_true')
    parser.add_argument(
        'json_file',
        help='JSON file of the model to generate corresponding python code',
        type=str, nargs='*')

    args = parser.parse_args()

    if args.all:
        # `all` flag overrides `json_file` & `verbose`
        all_json_files = PATH_MODELS.glob('*.json')
        for json_fn in all_json_files:
            main(json_fn, False)
    else:
        main(args.json_file, args.verbose)
