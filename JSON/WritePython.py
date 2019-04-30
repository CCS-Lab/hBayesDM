#!/usr/bin/env python3
"""
Written by Jethro Lee.
"""
import sys
import argparse
import glob
import json
import re
from pathlib import Path
from typing import List, Iterable, Callable
from collections import OrderedDict


def main(json_file, verbose):
    # Make Path object for given filename
    path_fn = Path(json_file)

    # Check if file exists
    if not path_fn.exists():
        print('FileNotFound: Please specify existing json_file as argument.')
        sys.exit(1)

    # Load json_file
    with open(path_fn, 'r') as f:
        model_info = json.load(f, object_pairs_hook=OrderedDict)

    # Model full name (Snake-case)
    model_function = path_fn.name.replace('.json', '')

    # Model class name (Pascal-case)
    class_name = model_function.title().replace('_', '')

    # Prefix to preprocess_func
    prefix_preprocess_func = model_info['task_name']['code']
    if model_info['model_type']['code']:
        prefix_preprocess_func += '_' + model_info['model_type']['code']

    # Preprocess citations
    def shortify(cite: str) -> str:
        last_name = cite[:cite.find(',')].replace(' ', '_')
        m = re.search('\\((\\d{4})\\)', cite)
        year = m.group(1) if m else ''
        return last_name + year
    task_cite = OrderedDict(
        (shortify(cite), cite) for cite in model_info['task_name']['cite'])
    model_cite = OrderedDict(
        (shortify(cite), cite) for cite in model_info['model_name']['cite'])

    # Read template for docstring
    with open('PY_DOCSTRING_TEMPLATE.txt', 'r') as f:
        docstring_template = f.read().format(
            model_function=model_function,
            task_name=model_info['task_name']['desc'],
            task_cite_short=format_list(
                task_cite,
                fmt='[{}]_',
                sep=', '),
            task_cite_long=format_dict(
                task_cite,
                fmt='.. [{}] {}',
                sep='\n    '),
            model_name=model_info['model_name']['desc'],
            model_cite_short=format_list(
                model_cite,
                fmt='[{}]_',
                sep=', '),
            model_cite_long=format_dict(
                OrderedDict((k, v) for k, v in model_cite.items()
                            if k not in task_cite),
                fmt='.. [{}] {}',
                sep='\n    '),
            model_type=model_info['model_type']['desc'],
            notes=format_list(
                model_info['notes'],
                fmt='.. note::\n        {}',
                sep='\n\n    '),
            contributors=format_list_of_dict(
                model_info['contributors'],
                'name', 'email',
                fmt='.. codeauthor:: {} <{}>',
                sep='\n    '),
            data_columns=format_list(
                model_info['data_columns'],
                fmt='"{}"',
                sep=', '),
            data_columns_len=len(model_info['data_columns']),
            data_columns_details=format_dict(
                model_info['data_columns'],
                fmt='- "{}": {}',
                sep='\n    '),
            parameters=format_dict(
                model_info['parameters'],
                fmt='"{}" ({})',
                sep=', ',
                pre=lambda v: v['desc']),
            model_regressor_parameter=message_model_regressor_parameter(
                model_info['regressors']),
            model_regressor_return=message_model_regressor_return(
                model_info['regressors']),
            postpreds=message_postpreds(model_info['postpreds']),
            additional_args=message_additional_args(
                model_info['additional_args']),
        )

    # Read template for model python code
    with open('PY_CODE_TEMPLATE.txt', 'r') as f:
        code_template = f.read().format(
            docstring_template=docstring_template,
            model_function=model_function,
            class_name=class_name,
            prefix_preprocess_func=prefix_preprocess_func,
            task_name=model_info['task_name']['code'],
            model_name=model_info['model_name']['code'],
            model_type=model_info['model_type']['code'],
            data_columns=format_list(
                model_info['data_columns'],
                fmt="'{}',",
                sep='\n                '),
            parameters=format_dict(
                model_info['parameters'],
                fmt="('{}', ({})),",
                sep='\n                ',
                pre=lambda v: ', '.join(map(str, v['info']))),
            regressors=format_dict(
                model_info['regressors'],
                fmt="('{}', {}),",
                sep='\n                '),
            postpreds=format_list(
                model_info['postpreds'],
                fmt="'{}'",
                sep=', '),
            parameters_desc=format_dict(
                model_info['parameters'],
                fmt="('{}', '{}'),",
                sep='\n                ',
                pre=lambda v: v['desc']),
            additional_args_desc=format_list_of_dict(
                model_info['additional_args'],
                'code', 'default',
                fmt="('{}', {}),",
                sep='\n                '),
        )

    if verbose:
        # Print code string to stdout
        print(code_template)
    else:
        # Write model python code
        code_fn = '_' + model_function + '.py'
        with open(code_fn, 'w') as f:
            f.write('"""\nGenerated by template. Do not edit by hand.\n"""\n')
            f.write(code_template)
        print('Created file: ' + code_fn)


def format_list(data: Iterable,
                fmt: str,
                sep: str) -> str:
    return sep.join(map(fmt.format, data))


def format_dict(data: OrderedDict,
                fmt: str,
                sep: str,
                pre: Callable = lambda v: v) -> str:
    return sep.join(fmt.format(k, pre(v)) for k, v in data.items())


def format_list_of_dict(data: List[OrderedDict],
                        *keys: str,
                        fmt: str,
                        sep: str) -> str:
    return sep.join(fmt.format(*(d[k] for k in keys)) for d in data)


def message_model_regressor_parameter(regressors: OrderedDict) -> str:
    if regressors:
        return 'For this model they are: ' + format_list(
            regressors, fmt='"{}"', sep=', ')
    else:
        return 'Currently not available for this model'


def message_model_regressor_return(regressors: OrderedDict) -> str:
    if regressors:
        return (
            '- ``model_regressor``: '
            + 'Dict holding the extracted model-based regressors.')
    else:
        return ''


def message_postpreds(postpreds: List) -> str:
    if not postpreds:
        return '**(Currently not available.)** '
    else:
        return ''


def message_additional_args(additional_args: List) -> str:
    if additional_args:
        return (
            'For this model, it\'s possible to set the following model-'
            + 'specific argument to a value that you may prefer.\n\n        '
            + format_list_of_dict(
                additional_args,
                'code', 'desc',
                fmt='- ``{}``: {}',
                sep='\n        '))
    else:
        return 'Not used for this model.'


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
        type=str)

    args = parser.parse_args()

    if args.all:
        # `all` flag overrides `json_file` & `verbose`
        all_json_files = glob.glob('[a-z]*.json')
        for json_fn in all_json_files:
            main(json_fn, False)
    else:
        main(args.json_file, args.verbose)
