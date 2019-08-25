from typing import List, Dict, Sequence, Union

import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import arviz as az

from hbayesdm.base import TaskModel

__all__ = ['rhat', 'print_fit', 'hdi', 'plot_hdi', 'extract_ic']


def rhat(model_data: TaskModel,
         less: float = None) -> Dict[str, Union[List, bool]]:
    """Function for extracting Rhat values from hbayesdm output.

    Convenience function for extracting Rhat values from hbayesdm output.
    Also possible to check if all Rhat values are less than a specified value.

    Parameters
    ----------
    model_data
        Output instance of running an hbayesdm model function.
    less
        [Optional] Upper-bound value to compare extracted Rhat values to.

    Returns
    -------
    Dict
        Keys are names of the parameters; values are their Rhat values.
        Or if `less` was specified, the dictionary values will hold `True` if
        all Rhat values (of that parameter) are less than or equal to `less`.
    """
    rhat_data = az.rhat(model_data.fit)
    if less is None:
        return {v.name: v.values.tolist()
                for v in rhat_data.data_vars.values()}
    else:
        return {v.name: v.values.item()
                for v in (rhat_data.max() <= less).data_vars.values()}


def print_fit(*args: TaskModel, ic: str = 'looic') -> pd.DataFrame:
    """Print model-fits (mean LOOIC or WAIC values) of hbayesdm models.

    Parameters
    ----------
    args
        Output instances of running hbayesdm model functions.
    ic
        Information criterion (defaults to 'looic').

    Returns
    -------
    pd.DataFrame
        Model-fit info per each hbayesdm output given as argument(s).
    """
    ic_options = ('looic', 'waic')
    if ic not in ic_options:
        raise RuntimeError(
            'Information Criterion (ic) must be one of ' + repr(ic_options))
    dataset_dict = {
        model_data.model:
            az.from_pystan(model_data.fit, log_likelihood='log_lik')
        for model_data in args
    }

    ic = 'loo' if ic == 'looic' else 'waic'
    return az.compare(dataset_dict=dataset_dict, ic=ic)


def hdi(x: np.ndarray, credible_interval: float = 0.94) -> np.ndarray:
    """Calculate highest density interval (HDI).

    This function acts as an alias to `arviz.hpd` function.

    Parameters
    ----------
    x
        Array containing MCMC samples.
    credible_interval
        Credible interval to compute. Defaults to 0.94.

    Returns
    -------
    np.ndarray
        Array containing the lower and upper value of the computed interval.
    """
    return az.hpd(x, credible_interval=credible_interval)


def plot_hdi(x: np.ndarray,
             credible_interval: float = 0.94,
             title: str = None,
             xlabel: str = 'Value',
             ylabel: str = 'Density',
             point_estimate: str = None,
             bins: Union[int, Sequence, str] = 'auto',
             round_to: int = 2,
             **kwargs):
    """Plot highest density interval (HDI).

    This function redirects input to `arviz.plot_posterior` function.

    Parameters
    ----------
    x
        Array containing MCMC samples.
    credible_interval
        Credible interval to plot. Defaults to 0.94.
    title
        String to set as title of plot.
    xlabel
        String to set as the x-axis label.
    ylabel
        String to set as the y-axis label.
    point_estimate
        Defaults to None. Possible options are 'mean', 'median', 'mode'.
    bins
        Controls the number of bins. Defaults to 'auto'.
        Accepts the same values (or keywords) as plt.hist() does.
    round_to
        Controls formatting for floating point numbers. Defaults to 2.
    **kwargs
        Passed as-is to plt.hist().
    """
    kwargs.setdefault('color', 'black')
    ax = az.plot_posterior(x,
                           kind='hist',
                           credible_interval=credible_interval,
                           point_estimate=point_estimate,
                           bins=bins,
                           round_to=round_to,
                           **kwargs).item()
    ax.set_title(title)
    ax.set_xlabel(xlabel)
    ax.set_ylabel(ylabel)
    plt.show()


def extract_ic(model_data: TaskModel,
               ic: str = 'both',
               ncore: int = 2) \
        -> Dict:
    """Extract model comparison estimates.

    Parameters
    ----------
    model_data
        hBayesDM output objects from running model functions.
    ic
        Information criterion. 'looic', 'waic', or 'both'. Defaults to 'both'.
    ncore
        Number of cores to use when computing LOOIC. Defaults to 2.

    Returns
    -------
    Dict
        Leave-One-Out and/or Watanabe-Akaike information criterion estimates.
    """
    ic_options = ('looic', 'waic', 'both')
    if ic not in ic_options:
        raise RuntimeError(
            'Information Criterion (ic) must be one of ' + repr(ic_options))

    dat = az.from_pystan(model_data.fit, log_likelihood='log_lik')

    ret = {}

    if ic in ['looic', 'both']:
        ret['looic'] = az.loo(dat)['loo']

    if ic in ['waic', 'both']:
        ret['waic'] = az.waic(dat)['waic']

    return ret
