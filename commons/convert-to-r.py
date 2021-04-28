"""
Generate R codes for hBayesDM using model information defined in YAML files.

.. moduleauthor:: Jethro Lee <dlemfh96@snu.ac.kr>
.. moduleauthor:: Jaeyeong Yang <jaeyeong.yang1125@gmail.com>
"""
import argparse
import re
import sys
from collections import OrderedDict
from pathlib import Path

import yaml

try:
    from yaml import CDumper as Dumper
    from yaml import CLoader as Loader
except ImportError:
    from yaml import Dumper, Loader


def represent_none(self, _):
    return self.represent_scalar('tag:yaml.org,2002:null', '')


Dumper.add_representer(type(None), represent_none)

PATH_ROOT = Path(__file__).absolute().parent
PATH_MODELS = PATH_ROOT / 'models'
PATH_TEMPLATE = PATH_ROOT / 'templates'
PATH_OUTPUT = PATH_ROOT / '_r-codes'
PATH_OUTPUT_TEST = PATH_ROOT / '_r-tests'

TEMPLATE_DOCS = PATH_TEMPLATE / 'R_DOCS_TEMPLATE.txt'
TEMPLATE_CODE = PATH_TEMPLATE / 'R_CODE_TEMPLATE.txt'
TEMPLATE_TEST = PATH_TEMPLATE / 'R_TEST_TEMPLATE.txt'


def ordered_load(stream, Loader=Loader, object_pairs_hook=OrderedDict):
    class OrderedLoader(Loader):
        pass

    def construct_mapping(loader, node):
        loader.flatten_mapping(node)
        return object_pairs_hook(loader.construct_pairs(node))
    OrderedLoader.add_constructor(
        yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG,
        construct_mapping)
    return yaml.load(stream, OrderedLoader)


def ordered_dump(data, stream=None, Dumper=Dumper, **kwds):
    class OrderedDumper(Dumper):
        pass

    def _dict_representer(dumper, data):
        return dumper.represent_mapping(
            yaml.resolver.BaseResolver.DEFAULT_MAPPING_TAG,
            data.items())
    OrderedDumper.add_representer(OrderedDict, _dict_representer)
    return yaml.dump(data, stream, OrderedDumper, **kwds)


def parse_cite_string(cite):
    """Parse given APA citation string into a dict object"""
    if not cite:
        return None

    fullcite = cite.replace('\n', '')

    regex_authoryear = r'(?P<authors>^.+?)\s\((?P<year>\d+?)\)'
    regex_author = r'(?=\s\&)?\s?(?P<author>[^,&]+?,\s[^,&]+?)(?=,|\n|\r|$)'

    m_ay = re.search(regex_authoryear, fullcite)
    year = m_ay.group('year')

    authors = []
    for m in re.finditer(regex_author, m_ay.group('authors')):
        authors.append(m.group('author'))

    firstauthor = authors[0].split(',')[0]
    shortcite = '{}{}'.format(firstauthor, year)
    if len(authors) == 1:
        barecite = '{}, {}'.format(firstauthor, year)
    else:
        barecite = '{} et al., {}'.format(firstauthor, year)

    return {
        'authors': authors,
        'year': year,
        'shortcite': shortcite,
        'barecite': barecite,
        'fullcite': fullcite
    }


def format_parencite(cites):
    if len(cites) == 0:
        return ''
    return '(' + '; '.join([c['barecite'] for c in cites if c]) + ')'


def format_fullcite(cites, sep='\n#\' '):
    if len(cites) == 0:
        return ''
    return sep.join([c['fullcite'] for c in cites if c])


def format_references_block(cites_formatted):
    return f"""#' @references
#' {cites_formatted}
#'
"""


def generate_docs(info):
    # Model full name (Snake-case)
    model_function = [info['task_name']['code'], info['model_name']['code']]
    if info['model_type']['code']:
        model_function.append(info['model_type']['code'])
    model_function = '_'.join(model_function)

    # Citations
    if info['task_name'].get('cite'):
        task_cite = [parse_cite_string(c) for c in info['task_name']['cite']]
    else:
        task_cite = []

    if info['model_name'].get('cite'):
        model_cite = [parse_cite_string(c) for c in info['model_name']['cite']]
    else:
        model_cite = []

    task_parencite = format_parencite(task_cite)
    model_parencite = format_parencite(model_cite)

    if len(task_cite + model_cite) > 0:
        references = format_fullcite(task_cite + model_cite, sep='\n#\'\n#\' ')
        references = format_references_block(references)
    else:
        references = ''

    # Notes
    if info.get('notes'):
        notes = '#\' @note\n#\' \\strong{Notes:}\n#\' ' + \
                '\n#\' '.join(info['notes'])
        notes = '\n#\' ' + notes + '\n#\''
    else:
        notes = ''

    # Contributors
    if info.get('contributors'):
        contributors = ', '.join([
            r'\href{%s}{%s} <\email{%s}>'
            % (c['link'], c['name'], c['email'].replace('@', '@@'))
            for c in info['contributors']
        ])
    else:
        contributors = ''

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
    if info.get('regressors'):
        regressors = ', '.join([
            '"%s"' % k for k in info['regressors'].keys()
        ])
    else:
        regressors = ''

    # Postpreds
    if info.get('postpreds'):
        postpreds = ', '.join(['"%s"' % v for v in info['postpreds']])
    else:
        postpreds = ''

    # Additional arguments
    if info.get('additional_args'):
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
        additional_args_len = 0
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
    if info['model_type']['code']:
        model_function.append(info['model_type']['code'])
    model_function = '_'.join(model_function)

    # Prefix to preprocess_func
    prefix_preprocess_func = info['task_name']['code']
    if info['model_type']['code']:
        prefix_preprocess_func += '_' + info['model_type']['code']
    preprocess_func = prefix_preprocess_func + '_preprocess_func'

    # Model type code
    model_type_code = info['model_type'].get('code')
    if model_type_code is None:
        model_type_code = ''

    # Data columns
    data_columns = ', '.join([
        r'"%s"' % k for k in info.get('data_columns', {}).keys()
    ])

    # Parameters
    _params = info.get('parameters', {})
    if _params and len(_params) > 0:
        parameters = ',\n    '.join([
            '"{}" = c({}, {}, {})'
            .format(k,
                    v['info'][0] if v['info'][0] is not None else 'NULL',
                    v['info'][1] if v['info'][1] is not None else 'NULL',
                    v['info'][2] if v['info'][2] is not None else 'NULL')
            for k, v in _params.items()
        ])
        parameters = 'list(\n    ' + parameters + '\n  )'
    else:
        parameters = 'NULL'

    # Regressors
    _regs = info.get('regressors', {})
    if _regs and len(_regs) > 0:
        regressors = ',\n    '.join([
            '"{}" = {}'.format(k, v) for k, v in _regs.items()
        ])
        regressors = 'list(\n    ' + regressors + '\n  )'
    else:
        regressors = 'NULL'

    # Postpreds
    _postpreds = info.get('postpreds', [])
    if _postpreds and len(_postpreds) > 0:
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
        model_type=model_type_code,
        data_columns=data_columns,
        parameters=parameters,
        regressors=regressors,
        postpreds=postpreds,
        preprocess_func=preprocess_func,
    )

    return code


def generate_test(info):
    # Model full name (Snake-case)
    model_function = [info['task_name']['code'], info['model_name']['code']]
    if info['model_type']['code']:
        model_function.append(info['model_type']['code'])
    model_function = '_'.join(model_function)

    # Read template for model tests
    with open(TEMPLATE_TEST, 'r') as f:
        test_template = f.read()

    test = test_template % dict(model_function=model_function)

    return test


def main(info_fn):
    # Check if file exists
    if not info_fn.exists():
        print('FileNotFound:', info_fn)
        sys.exit(1)

    # Load model information
    with open(info_fn, 'r') as f:
        info = ordered_load(f, Loader=Loader)

    # Generate codes
    docs = generate_docs(info)
    code = generate_code(info)
    test = generate_test(info)
    output = docs + code

    # Model full name (Snake-case)
    model_function = [info['task_name']['code'],
                      info['model_name']['code']]
    if info['model_type']['code']:
        model_function.append(info['model_type']['code'])
    model_function = '_'.join(model_function)

    # Make directories if not exist
    if not PATH_OUTPUT.exists():
        PATH_OUTPUT.mkdir(exist_ok=True)
    if not PATH_OUTPUT_TEST.exists():
        PATH_OUTPUT_TEST.mkdir(exist_ok=True)

    # Write model codes
    code_fn = PATH_OUTPUT / (model_function + '.R')
    with open(code_fn, 'w') as f:
        f.write(output)

    # Write test codes
    test_fn = PATH_OUTPUT_TEST / ('test_' + model_function + '.R')
    with open(test_fn, 'w') as f:
        f.write(test)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument(
        '-v', '--verbose',
        help='Whether to print its process.',
        action='store_true')
    parser.add_argument(
        'info_files',
        help='YAML-formatted file(s) for model information.',
        type=str,
        nargs='*')

    args = parser.parse_args()

    if args.info_files:
        info_fns = [PATH_MODELS / fn for fn in args.info_files]
    else:
        info_fns = sorted(PATH_MODELS.glob('*.yml'))

    num_models = len(info_fns)

    for i, info_fn in enumerate(info_fns):
        main(info_fn)
        if args.verbose:
            print('[{:2d} / {:2d}] Done for {}'
                  .format(i + 1, num_models, info_fn))
