"""
Generate Python codes for hBayesDM using model information defined in YAML
files.

.. moduleauthor:: Jethro Lee <dlemfh96@snu.ac.kr>
.. moduleauthor:: Jaeyeong Yang <jaeyeong.yang1125@gmail.com>
"""
import sys
import argparse
import re
from pathlib import Path
from collections import OrderedDict

import yaml
try:
    from yaml import CLoader as Loader, CDumper as Dumper
except ImportError:
    from yaml import Loader, Dumper


def represent_none(self, _):
    return self.represent_scalar('tag:yaml.org,2002:null', '')


Dumper.add_representer(type(None), represent_none)

PATH_ROOT = Path(__file__).absolute().parent
PATH_MODELS = PATH_ROOT / 'models'
PATH_TEMPLATE = PATH_ROOT / 'templates'
PATH_OUTPUT_CODE = PATH_ROOT / '_py-codes'
PATH_OUTPUT_TEST = PATH_ROOT / '_py-tests'

TEMPLATE_DOCS = PATH_TEMPLATE / 'PY_DOCS_TEMPLATE.txt'
TEMPLATE_CODE = PATH_TEMPLATE / 'PY_CODE_TEMPLATE.txt'
TEMPLATE_TEST = PATH_TEMPLATE / 'PY_TEST_TEMPLATE.txt'


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


def format_list(data, fmt, sep):
    return sep.join(map(fmt.format, data))


def format_dict(data, fmt, sep, pre=lambda v: v):
    return sep.join(fmt.format(k, pre(v)) for k, v in data.items())


def format_list_of_dict(data, *keys, fmt, sep):
    return sep.join(fmt.format(*(d[k] for k in keys)) for d in data)


def message_model_regressor_parameter(regressors):
    if regressors:
        return 'For this model they are: ' + format_list(
            regressors, fmt='"{}"', sep=', ')
    else:
        return 'Currently not available for this model'


def message_model_regressor_return(regressors):
    if regressors:
        return (
            '- ``model_regressor``: '
            + 'Dict holding the extracted model-based regressors.')
    else:
        return ''


def message_postpreds(postpreds):
    if not postpreds:
        return '**(Currently not available.)** '
    else:
        return ''


def message_additional_args(additional_args):
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


def main(info_fn):
    # Check if file exists
    if not info_fn.exists():
        print('FileNotFound:', info_fn)
        sys.exit(1)

    # Load model information
    with open(info_fn, 'r') as f:
        info = ordered_load(f, Loader=Loader)

    # Model full name (Snake-case)
    model_function = [info['task_name']['code'], info['model_name']['code']]
    if info['model_type']['code']:
        model_function.append(info['model_type']['code'])
    model_function = '_'.join(model_function)

    # Model class name (Pascal-case)
    class_name = model_function.title().replace('_', '')

    # Prefix to preprocess_func
    prefix_preprocess_func = info['task_name']['code']
    if info['model_type']['code']:
        prefix_preprocess_func += '_' + info['model_type']['code']

    # Model type code
    model_type_code = info['model_type'].get('code')
    if model_type_code is None:
        model_type_code = ''

    # Preprocess citations
    def shortify(cite: str) -> str:
        last_name = cite[:cite.find(',')].replace(' ', '_')
        m = re.search('\\((\\d{4})\\)', cite)
        year = m.group(1) if m else ''
        return last_name + year

    if info['task_name'].get('cite'):
        task_cite = OrderedDict(
            (shortify(cite), cite) for cite in info['task_name']['cite'])
    else:
        task_cite = {}

    if info['model_name'].get('cite'):
        model_cite = OrderedDict(
            (shortify(cite), cite) for cite in info['model_name']['cite'])
    else:
        model_cite = {}

    # Read template for docstring
    with open(TEMPLATE_DOCS, 'r') as f:
        docstring_template = f.read().format(
            model_function=model_function,
            task_name=info['task_name']['desc'],
            task_cite_short=format_list(
                task_cite,
                fmt='[{}]_',
                sep=', '),
            task_cite_long=format_dict(
                task_cite,
                fmt='.. [{}] {}',
                sep='\n    '),
            model_name=info['model_name']['desc'],
            model_cite_short=format_list(
                model_cite,
                fmt='[{}]_',
                sep=', '),
            model_cite_long=format_dict(
                OrderedDict((k, v) for k, v in model_cite.items()
                            if k not in task_cite),
                fmt='.. [{}] {}',
                sep='\n    '),
            model_type=info['model_type']['desc'],
            notes=format_list(
                info.get('notes') if info.get('notes') else [],
                fmt='.. note::\n        {}',
                sep='\n\n    '),
            contributors=format_list_of_dict(
                info.get('contributors') if info.get('contributors') else [],
                'name', 'email',
                fmt='.. codeauthor:: {} <{}>',
                sep='\n    '),
            data_columns=format_list(
                info['data_columns'],
                fmt='"{}"',
                sep=', '),
            data_columns_len=len(info['data_columns']),
            data_columns_details=format_dict(
                info['data_columns'],
                fmt='- "{}": {}',
                sep='\n    '),
            parameters=format_dict(
                info['parameters'],
                fmt='"{}" ({})',
                sep=', ',
                pre=lambda v: v['desc']),
            model_regressor_parameter=message_model_regressor_parameter(
                info['regressors']),
            model_regressor_return=message_model_regressor_return(
                info['regressors']),
            postpreds=message_postpreds(info['postpreds']),
            additional_args=message_additional_args(
                info['additional_args']),
        )

    # Read template for model python code
    with open(TEMPLATE_CODE, 'r') as f:
        code_template = f.read().format(
            docstring_template=docstring_template,
            model_function=model_function,
            class_name=class_name,
            prefix_preprocess_func=prefix_preprocess_func,
            task_name=info['task_name']['code'],
            model_name=info['model_name']['code'],
            model_type=model_type_code,
            data_columns=format_list(
                info['data_columns'],
                fmt="'{}',",
                sep='\n                '),
            parameters=format_dict(
                info['parameters'],
                fmt="('{}', ({})),",
                sep='\n                ',
                pre=lambda v: ', '.join(map(str, v['info']))),
            regressors=format_dict(
                info.get('regressors') if info.get('regressors') else {},
                fmt="('{}', {}),",
                sep='\n                '),
            postpreds=format_list(
                info.get('postpreds') if info.get('postpreds') else [],
                fmt="'{}'",
                sep=', '),
            parameters_desc=format_dict(
                info['parameters'],
                fmt="('{}', '{}'),",
                sep='\n                ',
                pre=lambda v: v['desc']),
            additional_args_desc=format_list_of_dict(
                info.get('additional_args') if info.get('additional_args') else
                [],
                'code', 'default',
                fmt="('{}', {}),",
                sep='\n                '),
        )

    with open(TEMPLATE_TEST, 'r') as f:
        test_template = f.read()

    test = test_template.format(model_function=model_function)

    # Make directories if not exist
    if not PATH_OUTPUT_CODE.exists():
        PATH_OUTPUT_CODE.mkdir(exist_ok=True)
    if not PATH_OUTPUT_TEST.exists():
        PATH_OUTPUT_TEST.mkdir(exist_ok=True)

    # Write model codes
    code_fn = PATH_OUTPUT_CODE / ('_' + model_function + '.py')
    with open(code_fn, 'w') as f:
        f.write(code_template)

    # Write test codes
    test_fn = PATH_OUTPUT_TEST / ('test_' + model_function + '.py')
    with open(test_fn, 'w') as f:
        f.write(test)


def generate_init(info_fns):
    mfs = []

    for info_fn in info_fns:
        # Load model information
        with open(info_fn, 'r') as f:
            info = ordered_load(f, Loader=Loader)

        # Model full name (Snake-case)
        model_function = [info['task_name']['code'],
                          info['model_name']['code']]
        if info['model_type']['code']:
            model_function.append(info['model_type']['code'])
        model_function = '_'.join(model_function)

        mfs.append(model_function)

    lines = []
    lines += ['from ._{mf} import {mf}'.format(mf=mf) for mf in mfs]
    lines += ['']
    lines += ['__all__ = [']
    lines += ['    \'{mf}\','.format(mf=mf) for mf in mfs]
    lines += [']']

    with open(PATH_OUTPUT_CODE / '__init__.py', 'w') as f:
        f.write('\n'.join(lines))


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

    generate_init(sorted(PATH_MODELS.glob('*.yml')))
