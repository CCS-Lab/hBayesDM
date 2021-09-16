hBayesDM
========

This is the Python version of *hBayesDM* (hierarchical Bayesian modeling of
Decision-Making tasks), a user-friendly package that offers hierarchical
Bayesian analysis of various computational models on an array of
decision-making tasks. *hBayesDM* in Python uses `PyStan`_ (Python interface for
`Stan`_) for Bayesian inference.

.. _PyStan: https://github.com/stan-dev/pystan
.. _Stan: https://mc-stan.org/

It supports Python 3.5 or higher versions and requires several packages including:
`NumPy`_, `SciPy`_, `Pandas`_, `PyStan`_, `Matplotlib`_, and `ArviZ`_.

.. WARNING:: The current Python implementation depends on functions of `PyStan`_ 2,
   not the latest version of `PyStan`_. As the latest PyStan does not support Windows
   for now, we plan to migrate the backend package for Stan from PyStan to
   `cmdstanpy`_ in a near future. Until then, we recommend you to try the R version
   instead or to use the current implementation with PyStan 2.19.1.1. Sorry for your
   inconvenience, and please stay tuned for the future update.

.. _NumPy: https://www.numpy.org/
.. _SciPy: https://www.scipy.org/
.. _Pandas: https://pandas.pydata.org/
.. _Matplotlib: https://matplotlib.org/
.. _ArviZ: https://arviz-devs.github.io/arviz/
.. _cmdstanpy: https://github.com/stan-dev/cmdstanpy

- **Documentation**: http://hbayesdm.readthedocs.io/

Installation
------------

You can install hBayesDM from PyPI with the following line:

.. code:: bash

   pip install "pystan==2.19.1.1"  # Use PyStan 2, for now
   pip install hbayesdm  # Install using pip

If you want to install the development version:

.. code:: bash

   pip install "git+https://github.com/CCS-Lab/hBayesDM.git@develop#egg=hbayesdm&subdirectory=Python"

Citation
--------

If you used hBayesDM or some of its codes for your research, please cite `this paper`_:

.. _this paper: https://www.mitpressjournals.org/doi/full/10.1162/CPSY_a_00002

.. code:: bibtex

   @article{hBayesDM,
     title = {Revealing Neurocomputational Mechanisms of Reinforcement Learning and Decision-Making With the {hBayesDM} Package},
     author = {Ahn, Woo-Young and Haines, Nathaniel and Zhang, Lei},
     journal = {Computational Psychiatry},
     year = {2017},
     volume = {1},
     pages = {24--57},
     publisher = {MIT Press},
     url = {doi:10.1162/CPSY_a_00002},
   }
