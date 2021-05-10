#!/usr/bin/env python3
import os
import subprocess
import sys
from pathlib import Path

from setuptools import find_packages, setup

if sys.version_info[:2] < (3, 5):
    raise RuntimeError("Python version >= 3.5 required.")


PATH_ROOT = Path(__file__).absolute().parent


MAJOR = 1
MINOR = 1
MICRO = 1
VERSION = '%d.%d.%d' % (MAJOR, MINOR, MICRO)

IS_RELEASED = True
IS_DEV = False
DEV_VERSION = 'a3'
if IS_RELEASED:
    pass
elif IS_DEV:
    VERSION += '.' + DEV_VERSION
else:
    VERSION += '.9000'


DESC = 'Python interface for hBayesDM, hierarchical Bayesian modeling of RL-DM tasks'
with open('README.rst', 'r', encoding='utf-8') as f:
    LONG_DESC = f.read()
LONG_DESC_TYPE = 'text/x-rst'
AUTHOR = 'hBayesDM Developers'
AUTHOR_EMAIL = 'hbayesdm-users@googlegroups.com'
URL = 'https://github.com/CCS-Lab/hBayesDM'
LICENSE = 'GPLv3'
CLASSIFIERS = [
    'Environment :: Console',
    'Intended Audience :: Developers',
    'Intended Audience :: Science/Research',
    'License :: OSI Approved :: GNU General Public License v3 (GPLv3)',
    'Operating System :: OS Independent',
    'Programming Language :: Python',
    'Programming Language :: Python :: 3',
    'Programming Language :: Python :: 3.5',
    'Programming Language :: Python :: 3.6',
    'Programming Language :: Python :: 3.7',
    'Topic :: Scientific/Engineering',
]

setup(
    name='hbayesdm',
    version=VERSION,
    author='hBayesDM Developers',
    author_email='hbayesdm-users@googlegroups.com',
    description=DESC,
    long_description=LONG_DESC,
    long_description_content_type=LONG_DESC_TYPE,
    python_requires='>=3.5',
    url=URL,
    license=LICENSE,
    classifiers=CLASSIFIERS,
    packages=find_packages(),
    install_requires=[
        'numpy',
        'scipy',
        'pandas',
        'pystan>=2.19.1,<3.0.0',
        'matplotlib',
        'arviz',
    ],
    zip_safe=False,
    include_package_data=True,
)
