hBayesDM
========

This is the Python version of *hBayesDM* (hierarchical Bayesian modeling of
Decision-Making tasks), a user-friendly package that offers hierarchical
Bayesian analysis of various computational models on an array of
decision-making tasks. *hBayesDM* in Python uses `cmdstanpy`_ (the Python
interface to `CmdStan`_) for Bayesian inference.

.. _cmdstanpy: https://mc-stan.org/cmdstanpy/
.. _CmdStan: https://mc-stan.org/users/interfaces/cmdstan
.. _Stan: https://mc-stan.org/

Requires **Python ≥ 3.13** and depends on `NumPy`_, `SciPy`_, `Pandas`_,
`cmdstanpy`_, `Matplotlib`_, and `ArviZ`_ (≥ 1.0).

.. _NumPy: https://www.numpy.org/
.. _SciPy: https://www.scipy.org/
.. _Pandas: https://pandas.pydata.org/
.. _Matplotlib: https://matplotlib.org/
.. _ArviZ: https://python.arviz.org/

- **Documentation**: http://hbayesdm.readthedocs.io/

Installation
------------

Install hBayesDM and its Python dependencies, then install CmdStan itself:

.. code:: bash

   pip install hbayesdm
   python -c "import cmdstanpy; cmdstanpy.install_cmdstan()"

Or, if you use `uv`_:

.. code:: bash

   uv add hbayesdm
   uv run python -c "import cmdstanpy; cmdstanpy.install_cmdstan()"

.. _uv: https://docs.astral.sh/uv/

For the development version:

.. code:: bash

   pip install "git+https://github.com/CCS-Lab/hBayesDM.git@develop#egg=hbayesdm&subdirectory=Python"

Each Stan model compiles on first use (~30 s) and cmdstanpy caches the
binary alongside the ``.stan`` file for subsequent fits.

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
