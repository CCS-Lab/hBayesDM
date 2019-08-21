hBayesDM-py
===========

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

   pip install hbayesdm                  # Install using pip

If you want to install from source (by cloning from GitHub):

.. code:: bash

   git clone https://github.com/CCS-Lab/hBayesDM.git
   cd hBayesDM
   cd Python

   python setup.py install               # Install from source
