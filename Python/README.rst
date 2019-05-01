hBayesDM-py
===========

.. image:: https://www.repostatus.org/badges/latest/wip.svg
   :alt: Project Status: WIP – Initial development is in progress,
         but there has not yet been a stable, usable release suitable
         for the public.
   :target: https://www.repostatus.org/#wip
.. image:: https://travis-ci.com/CCS-Lab/hBayesDM-py.svg?token=gbyEQoyAYgexeSRwBwj6&branch=master
   :alt: Travis CI
   :target: https://travis-ci.com/CCS-Lab/hBayesDM-py

This is the Python version of *hBayesDM* (hierarchical Bayesian modeling of
Decision-Making tasks), a user-friendly package that offers hierarchical
Bayesian analysis of various computational models on an array of
decision-making tasks. *hBayesDM* uses `PyStan`_ (Python interface for
`Stan`_) for Bayesian inference.

.. _PyStan: https://github.com/stan-dev/pystan
.. _Stan: http://mc-stan.org/

hBayesDM-py supports Python 3.5 or higher. It requires several packages including:

* `NumPy`_, `SciPy`_, `Pandas`_, `PyStan`_, `Matplotlib`_, `ArviZ`_

.. _NumPy: https://www.numpy.org/
.. _SciPy: https://www.scipy.org/
.. _Pandas: https://pandas.pydata.org/
.. _Matplotlib: https://matplotlib.org/
.. _ArviZ: https://arviz-devs.github.io/arviz/

Installation
------------

You can install hBayesDM-py from PyPI with the following line:

.. code:: bash

   pip install hbayesdm

If you want to install from source (via cloning from GitHub):

.. code:: bash

   git clone --recursive https://github.com/CCS-Lab/hBayesDM-py.git
   cd hBayesDM-py
   python setup.py install

If you want to make a virtual environment using `pipenv`_,
you can do so with the following command:

.. _pipenv: https://pipenv.readthedocs.io/en/latest/

.. code:: bash

   # After cloning (recursively) & cd-ing into hBayesDM-py
   pipenv install
   pipenv install --dev  # For developmental purpose
