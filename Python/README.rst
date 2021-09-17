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

.. WARNING:: The current Python implementation depends on `PyStan`_ 2,
   which is not the latest version (PyStan 3.*).
   In the matter of fact, the latest version of PyStan has different interfaces
   from those in PyStan 2, and it does not support Windows for now.
   In these points, we developers are concerned that it can affect the availability of hBayesDM
   for Windows users, so instead of updating hBayesDM to use PyStan 3, we plan to use
   `cmdstanpy`_ for our backend in a near future.
   Until then, we strongly recommend you to use the R version instead, but
   you can still use the current Python implementation with PyStan 2.19.1.1.
   Apologies for the inconvenience, and please stay tuned for the future update.

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
