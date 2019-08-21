#!/usr/bin/env python
import os
import sys
import subprocess
from setuptools import setup, find_packages

if sys.version_info[:2] < (3, 5):
    raise RuntimeError("Python version >= 3.5 required.")


MAJOR = 0
MINOR = 7
MICRO = 2
ISRELEASED = False
VERSION = '%d.%d.%d' % (MAJOR, MINOR, MICRO)


def git_version():
    """
    Return the git revision as a string
    """
    def _minimal_ext_cmd(cmd):
        # construct minimal environment
        env = {}
        for k in ['SYSTEMROOT', 'PATH', 'HOME']:
            v = os.environ.get(k)
            if v is not None:
                env[k] = v
        # LANGUAGE is used on win32
        env['LANGUAGE'] = 'C'
        env['LANG'] = 'C'
        env['LC_ALL'] = 'C'
        out = subprocess.Popen(
            cmd, stdout=subprocess.PIPE, env=env).communicate()[0]
        return out

    try:
        out = _minimal_ext_cmd(['git', 'rev-parse', 'HEAD'])
        GIT_REVISION = out.strip().decode('ascii')
    except OSError:
        GIT_REVISION = "Unknown"

    return GIT_REVISION


def get_version_info():
    # Adding the git rev number needs to be done inside write_version_py(),
    # otherwise the import of hbayesdm.version messes up the build under Python 3.
    FULLVERSION = VERSION
    if os.path.exists('.git'):
        GIT_REVISION = git_version()
    elif os.path.exists('hbayesdm/version.py'):
        # must be a source distribution, use existing version file
        try:
            from hbayesdm.version import git_revision as GIT_REVISION
        except ImportError:
            raise ImportError("Unable to import git_revision. Try removing "
                              "hbayesdm/version.py and the build directory "
                              "before building.")
    else:
        GIT_REVISION = "Unknown"

    if not ISRELEASED:
        # Following the R versioning convention
        FULLVERSION += '.9000'

    return FULLVERSION, GIT_REVISION


def write_version_py(filename='hbayesdm/version.py'):
    cnt = """
# THIS FILE IS GENERATED FROM HBAYESDM SETUP.PY
short_version = '%(version)s'
version = '%(version)s'
full_version = '%(full_version)s'
git_revision = '%(git_revision)s'
release = %(isrelease)s
if not release:
    version = full_version
"""
    FULLVERSION, GIT_REVISION = get_version_info()

    a = open(filename, 'w')
    try:
        a.write(cnt % {'version': VERSION,
                       'full_version': FULLVERSION,
                       'git_revision': GIT_REVISION,
                       'isrelease': str(ISRELEASED)})
    finally:
        a.close()


write_version_py()


DESC = 'Python interface for hBayesDM, hierarchical Bayesian modeling of RL-DM tasks'
with open('README.rst', 'r', encoding='utf-8') as f:
    LONG_DESC = f.read()
LONG_DESC_TYPE = 'text/restructuredtext'
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
        'pystan',
        'matplotlib',
        'arviz',
    ],
    zip_safe=False,
    include_package_data=True,
)
