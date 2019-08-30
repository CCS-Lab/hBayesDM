hBayesDM
========

This is the Python version of *hBayesDM* (hierarchical Bayesian modeling of
Decision-Making tasks), a user-friendly package that offers hierarchical
Bayesian analysis of various computational models on an array of
decision-making tasks. *hBayesDM* in Python uses `PyStan`_ (Python interface for
`Stan`_) for Bayesian inference.

.. _PyStan: https://github.com/stan-dev/pystan
.. _Stan: http://mc-stan.org/

It supports Python 3.5 or higher versions and requires several packages including:
`NumPy`_, `SciPy`_, `Pandas`_, `PyStan`_, `Matplotlib`_, and `ArviZ`_.

.. _NumPy: https://www.numpy.org/
.. _SciPy: https://www.scipy.org/
.. _Pandas: https://pandas.pydata.org/
.. _Matplotlib: https://matplotlib.org/
.. _ArviZ: https://arviz-devs.github.io/arviz/

- **Documentation**: http://hbayesdm.readthedocs.io/

Installation
------------

You can install hBayesDM from PyPI with the following line:

.. code:: bash

   pip install hbayesdm  # Install using pip

If you want to install from source (by cloning from GitHub):

.. code:: bash

   git clone https://github.com/CCS-Lab/hBayesDM.git
   cd hBayesDM
   cd Python

   python setup.py install  # Install from source

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
