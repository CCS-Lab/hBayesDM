from typing import Dict, List, Sequence, Union

import arviz as az
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd

from hbayesdm.base import TaskModel

__all__ = ['rhat', 'print_fit', 'hdi', 'plot_hdi', 'extract_ic']


def rhat(model_data: TaskModel,
         less: float = None) -> Dict[str, Union[List, bool]]:
    """Extract Rhat values from an hBayesDM model fit.

    Parameters
    ----------
    model_data
        A fitted ``TaskModel`` (the object returned by any task-model
        function, e.g. ``ra_prospect(...)``).
    less
        Optional threshold. When given, the function returns one boolean per
        parameter indicating whether the parameter's maximum Rhat is
        ``<= less`` (a common convergence check is ``less=1.05`` or
        ``less=1.1``). When omitted, raw Rhat values are returned.

    Returns
    -------
    dict
        ``{parameter_name: rhat_values}`` if ``less`` is None, where each
        ``rhat_values`` is a list (scalar parameters) or nested list
        (vector/matrix parameters). Otherwise
        ``{parameter_name: bool}`` indicating whether all of the parameter's
        Rhat values are below the threshold.
    """
    rhat_data = az.rhat(model_data.idata)
    if less is None:
        return {v.name: v.values.tolist()
                for v in rhat_data.data_vars.values()}
    return {v.name: v.values.item()
            for v in (rhat_data.max() <= less).data_vars.values()}


def print_fit(*args: TaskModel) -> pd.DataFrame:
    """Compare hBayesDM models by expected log-pointwise predictive density.

    Wraps ``arviz.compare``, which uses leave-one-out cross-validation
    (PSIS-LOO) to rank models. Lower ``elpd_diff`` values (and lower LOOIC)
    indicate better predictive fit.

    Parameters
    ----------
    *args
        Two or more fitted ``TaskModel`` objects.

    Returns
    -------
    pandas.DataFrame
        Comparison table indexed by model name, with columns including
        ``rank``, ``elpd_loo``, ``p_loo``, ``elpd_diff``, ``weight``, and
        ``se``. See ``arviz.compare`` for the full schema.
    """
    return az.compare({m.model: m.idata for m in args})


def hdi(x: np.ndarray, ci_prob: float = 0.95) -> np.ndarray:
    """Compute the highest density interval (HDI) of a posterior sample.

    Thin wrapper around ``arviz.hdi``. The HDI is the shortest interval
    containing ``ci_prob`` of the posterior mass.

    Parameters
    ----------
    x
        1-D array of posterior draws.
    ci_prob
        Credible mass to enclose. Defaults to 0.95.

    Returns
    -------
    numpy.ndarray
        Length-2 array ``[lower, upper]`` giving the HDI bounds.
    """
    return az.hdi(x, prob=ci_prob)


def plot_hdi(x: np.ndarray,
             ci_prob: float = 0.95,
             title: str = None,
             xlabel: str = 'Value',
             ylabel: str = 'Density',
             point_estimate: str = None,
             **kwargs):
    """Plot a posterior density with HDI shading.

    Parameters
    ----------
    x
        1-D array of posterior draws.
    ci_prob
        HDI credible mass. Defaults to 0.95.
    title, xlabel, ylabel
        Optional axis labels and title.
    point_estimate
        ``"mean"``, ``"median"``, ``"mode"``, or ``None`` to suppress the
        point-estimate marker. Forwarded to ``arviz.plot_dist``.
    **kwargs
        Additional keyword arguments forwarded to ``arviz.plot_dist``.
    """
    idata = az.from_dict({'posterior': {'x': np.asarray(x)[None, ...]}})
    az.plot_dist(idata,
                 var_names=['x'],
                 ci_prob=ci_prob,
                 point_estimate=point_estimate,
                 **kwargs)
    ax = plt.gca()
    if title is not None:
        ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    plt.show()


def extract_ic(model_data: TaskModel) -> Dict:
    """Extract leave-one-out information criterion estimates.

    Parameters
    ----------
    model_data
        A fitted ``TaskModel``.

    Returns
    -------
    dict
        ``{'looic': float, 'loo': arviz.ELPDData}``. ``looic`` is
        ``-2 * elpd_loo`` (the deviance-scale LOO information criterion);
        ``loo`` is the full ``ELPDData`` object exposing pointwise ELPD,
        Pareto-k diagnostics, and standard errors. Call ``arviz.loo`` on
        ``model_data.idata`` directly if you need additional options.
    """
    loo_result = az.loo(model_data.idata)
    return {'looic': float(loo_result.elpd) * -2,
            'loo': loo_result}
