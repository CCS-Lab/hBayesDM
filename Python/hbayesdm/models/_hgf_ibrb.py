from typing import Sequence, Union, Any
from collections import OrderedDict

from numpy import Inf, exp
import pandas as pd

from hbayesdm.base import TaskModel
from hbayesdm.preprocess_funcs import hgf_ibrb_preprocess_func

__all__ = ['hgf_ibrb']


class HgfIbrb(TaskModel):
    def __init__(self, **kwargs):
        super().__init__(
            task_name='',
            model_name='hgf_ibrb',
            model_type='',
            data_columns=(
                'subjID',
                'trialNum',
                'u',
                'y',
            ),
            parameters=OrderedDict([
                ('kappa', (0, 0, Inf)),
                ('omega', (-Inf, 0, Inf)),
                ('zeta', (0, 1, Inf)),
            ]),
            regressors=OrderedDict([
                
            ]),
            postpreds=[],
            parameters_desc=OrderedDict([
                ('kappa', 'phasic volatility for coupling with higher level for each level (2 ~ L-1)'),
                ('omega', 'tonic volatility for each level (2 ~ L)'),
                ('zeta', 'inverse decision noise, the tendency to choose the response that corresponds with one\'s current belief'),
            ]),
            additional_args=OrderedDict([
                ('L', 3),
                ('input_first', False),
                ('mu0', [0.5, 1.0]),
                ('sigma0', [0.1, 1.0]),
                ('kappa_lower', [0]),
                ('kappa_upper', [2]),
                ('omega_lower', [-10, -15]),
                ('omega_upper', [0, 0]),
                ('zeta_lower', 0),
                ('zeta_upper', 2),
            ]),
            additional_args_desc=OrderedDict([
                ('L', 'Total level of hierarchy. Defaults to minimum level of 3'),
                ('input_first', 'TRUE if participant observed u[t] before choosing y[t], FALSE if participant observed u[t] after choosing y[t]'),
                ('mu0', 'prior belief for each level before starting the experiment'),
                ('sigma0', 'prior uncertainty for each level before starting the experiment'),
                ('kappa_lower', 'Lower bounds for kappa for each level (2 ~ L-1). Defaults to [0] and can not be negative. Parameter value is fixed for level l if kappa_upper[l] == kappa_lower[l].'),
                ('kappa_upper', 'Upper bounds for kappa for each level (2 ~ L-1). Defaults to [3]. Parameter value is fixed for level l if kappa_upper[l] == kappa_lower[l].'),
                ('omega_lower', 'Lower bounds for omega for each level (2 ~ L). Defaults to [-10. -15]. Parameter value is fixed for level l if omega_upper[l] == omega_lower[l].'),
                ('omega_upper', 'Upper bounds for omega for each level (2 ~ L). Defaults to [5, 5]. Parameter value is fixed for level l if omega_upper[l] == omega_lower[l].'),
                ('zeta_lower', 'Upper bound for zeta. Defaults to 0 and can not be negative. Parameter value is fixed if zeta_lower == zeta_upper.'),
                ('zeta_upper', 'Upper bound for zeta. Defaults to 3. Parameter value is fixed if zeta_lower == zeta_upper.'),
            ]),
            **kwargs,
        )

    _preprocess_func = hgf_ibrb_preprocess_func


def hgf_ibrb(
        data: Union[pd.DataFrame, str, None] = None,
        niter: int = 4000,
        nwarmup: int = 1000,
        nchain: int = 4,
        ncore: int = 1,
        nthin: int = 1,
        inits: Union[str, Sequence[float]] = 'vb',
        ind_pars: str = 'mean',
        model_regressor: bool = False,
        vb: bool = False,
        inc_postpred: bool = False,
        adapt_delta: float = 0.95,
        stepsize: float = 1,
        max_treedepth: int = 10,
        **additional_args: Any) -> TaskModel:
    """ - Hierarchical Bayesian version of the Hierarchical Gaussian Filter model for binary inputs and binary responses

    Hierarchical Bayesian Modeling of the  
    using Hierarchical Bayesian version of the Hierarchical Gaussian Filter model for binary inputs and binary responses [Mathys_C2011]_, [Mathys_CD2014]_ with the following parameters:
    "kappa" (phasic volatility for coupling with higher level for each level (2 ~ L-1)), "omega" (tonic volatility for each level (2 ~ L)), "zeta" (inverse decision noise, the tendency to choose the response that corresponds with one\'s current belief).

    

    
    .. [Mathys_C2011] Mathys C, Daunizeau J, Friston KJ and Stephan KE (2011) A Bayesian foundation for individual learning under uncertainty. Front. Hum. Neurosci. 5:39. https://doi.org/10.3389/fnhum.2011.00039
    .. [Mathys_CD2014] Mathys CD, Lomakina EI, Daunizeau J, Iglesias S, Brodersen KH, Friston KJ and Stephan KE (2014) Uncertainty in perception and the Hierarchical Gaussian Filter. Front. Hum. Neurosci. 8:825. https://doi.org/10.3389/fnhum.2014.00825

    .. codeauthor:: Jinwoo Jeong <jwjeong96@gmail.com>

    User data should contain the behavioral data-set of all subjects of interest for
    the current analysis. When loading from a file, the datafile should be a
    **tab-delimited** text file, whose rows represent trial-by-trial observations
    and columns represent variables.

    For the , there should be 4 columns of data
    with the labels "subjID", "trialNum", "u", "y". It is not necessary for the columns to be
    in this particular order; however, it is necessary that they be labeled
    correctly and contain the information below:

    - "subjID": A unique identifier for each subject in the data-set.
    - "trialNum": Nominal integer representing the trial number: 1, 2, ...
    - "u": Integer value representing the input on that trial: 0 or 1.
    - "y": Integer value representing the subject's choice on that trial: 0 or 1.

    .. note::
        User data may contain other columns of data (e.g. ``ReactionTime``,
        ``trial_number``, etc.), but only the data within the column names listed
        above will be used during the modeling. As long as the necessary columns
        mentioned above are present and labeled correctly, there is no need to
        remove other miscellaneous data columns.

    .. note::

        ``adapt_delta``, ``stepsize``, and ``max_treedepth`` are advanced options that
        give the user more control over Stan's MCMC sampler. It is recommended that
        only advanced users change the default values, as alterations can profoundly
        change the sampler's behavior. See [Hoffman2014]_ for more information on the
        sampler control parameters. One can also refer to 'Section 34.2. HMC Algorithm
        Parameters' of the `Stan User's Guide and Reference Manual`__.

        .. [Hoffman2014]
            Hoffman, M. D., & Gelman, A. (2014).
            The No-U-Turn sampler: adaptively setting path lengths in Hamiltonian Monte Carlo.
            Journal of Machine Learning Research, 15(1), 1593-1623.

        __ https://mc-stan.org/users/documentation/

    Parameters
    ----------
    data
        Data to be modeled. It should be given as a Pandas DataFrame object,
        a filepath for a data file, or ``"example"`` for example data.
        Data columns should be labeled as: "subjID", "trialNum", "u", "y".
    niter
        Number of iterations, including warm-up. Defaults to 4000.
    nwarmup
        Number of iterations used for warm-up only. Defaults to 1000.

        ``nwarmup`` is a numerical value that specifies how many MCMC samples
        should not be stored upon the beginning of each chain. For those
        familiar with Bayesian methods, this is equivalent to burn-in samples.
        Due to the nature of the MCMC algorithm, initial values (i.e., where the
        sampling chains begin) can have a heavy influence on the generated
        posterior distributions. The ``nwarmup`` argument can be set to a
        higher number in order to curb the effects that initial values have on
        the resulting posteriors.
    nchain
        Number of Markov chains to run. Defaults to 4.

        ``nchain`` is a numerical value that specifies how many chains (i.e.,
        independent sampling sequences) should be used to draw samples from
        the posterior distribution. Since the posteriors are generated from a
        sampling process, it is good practice to run multiple chains to ensure
        that a reasonably representative posterior is attained. When the
        sampling is complete, it is possible to check the multiple chains for
        convergence by running the following line of code:

        .. code:: python

            output.plot(type='trace')
    ncore
        Number of CPUs to be used for running. Defaults to 1.
    nthin
        Every ``nthin``-th sample will be used to generate the posterior
        distribution. Defaults to 1. A higher number can be used when
        auto-correlation within the MCMC sampling is high.

        ``nthin`` is a numerical value that specifies the "skipping" behavior
        of the MCMC sampler. That is, only every ``nthin``-th sample is used to
        generate posterior distributions. By default, ``nthin`` is equal to 1,
        meaning that every sample is used to generate the posterior.
    inits
        String or list specifying how the initial values should be generated.
        Options are ``'fixed'`` or ``'random'``, or your own initial values.
    ind_pars
        String specifying how to summarize the individual parameters.
        Current options are: ``'mean'``, ``'median'``, or ``'mode'``.
    model_regressor
        Whether to export model-based regressors. Currently not available for this model.
    vb
        Whether to use variational inference to approximately draw from a
        posterior distribution. Defaults to ``False``.
    inc_postpred
        **(Currently not available.)** Include trial-level posterior predictive simulations in
        model output (may greatly increase file size). Defaults to ``False``.
    adapt_delta
        Floating point value representing the target acceptance probability of a new
        sample in the MCMC chain. Must be between 0 and 1. See note below.
    stepsize
        Integer value specifying the size of each leapfrog step that the MCMC sampler
        can take on each new iteration. See note below.
    max_treedepth
        Integer value specifying how many leapfrog steps the MCMC sampler can take
        on each new iteration. See note below.
    **additional_args
        For this model, it's possible to set the following model-specific argument to a value that you may prefer.

        - ``L``: Total level of hierarchy. Defaults to minimum level of 3
        - ``input_first``: TRUE if participant observed u[t] before choosing y[t], FALSE if participant observed u[t] after choosing y[t]
        - ``mu0``: prior belief for each level before starting the experiment
        - ``sigma0``: prior uncertainty for each level before starting the experiment
        - ``kappa_lower``: Lower bounds for kappa for each level (2 ~ L-1). Defaults to [0] and can not be negative. Parameter value is fixed for level l if kappa_upper[l] == kappa_lower[l].
        - ``kappa_upper``: Upper bounds for kappa for each level (2 ~ L-1). Defaults to [3]. Parameter value is fixed for level l if kappa_upper[l] == kappa_lower[l].
        - ``omega_lower``: Lower bounds for omega for each level (2 ~ L). Defaults to [-10. -15]. Parameter value is fixed for level l if omega_upper[l] == omega_lower[l].
        - ``omega_upper``: Upper bounds for omega for each level (2 ~ L). Defaults to [5, 5]. Parameter value is fixed for level l if omega_upper[l] == omega_lower[l].
        - ``zeta_lower``: Upper bound for zeta. Defaults to 0 and can not be negative. Parameter value is fixed if zeta_lower == zeta_upper.
        - ``zeta_upper``: Upper bound for zeta. Defaults to 3. Parameter value is fixed if zeta_lower == zeta_upper.

    Returns
    -------
    model_data
        An ``hbayesdm.TaskModel`` instance with the following components:

        - ``model``: String value that is the name of the model ('hgf_ibrb').
        - ``all_ind_pars``: Pandas DataFrame containing the summarized parameter values
          (as specified by ``ind_pars``) for each subject.
        - ``par_vals``: OrderedDict holding the posterior samples over different parameters.
        - ``fit``: A PyStan StanFit object that contains the fitted Stan model.
        - ``raw_data``: Pandas DataFrame containing the raw data used to fit the model,
          as specified by the user.
        

    Examples
    --------

    .. code:: python

        from hbayesdm import rhat, print_fit
        from hbayesdm.models import hgf_ibrb

        # Run the model and store results in "output"
        output = hgf_ibrb(data='example', niter=2000, nwarmup=1000, nchain=4, ncore=4)

        # Visually check convergence of the sampling chains (should look like "hairy caterpillars")
        output.plot(type='trace')

        # Plot posterior distributions of the hyper-parameters (distributions should be unimodal)
        output.plot()

        # Check Rhat values (all Rhat values should be less than or equal to 1.1)
        rhat(output, less=1.1)

        # Show the LOOIC and WAIC model fit estimates
        print_fit(output)
    """
    return HgfIbrb(
        data=data,
        niter=niter,
        nwarmup=nwarmup,
        nchain=nchain,
        ncore=ncore,
        nthin=nthin,
        inits=inits,
        ind_pars=ind_pars,
        model_regressor=model_regressor,
        vb=vb,
        inc_postpred=inc_postpred,
        adapt_delta=adapt_delta,
        stepsize=stepsize,
        max_treedepth=max_treedepth,
        **additional_args)
