from typing import Sequence, Union, Any
from collections import OrderedDict

from numpy import Inf, exp
import pandas as pd

from hbayesdm.base import TaskModel
from hbayesdm.preprocess_funcs import dd_single_preprocess_func

__all__ = ['dd_hyperbolic_single']


class DdHyperbolicSingle(TaskModel):
    def __init__(self, **kwargs):
        super().__init__(
            task_name='dd',
            model_name='hyperbolic',
            model_type='single',
            data_columns=(
                'subjID',
                'delay_later',
                'amount_later',
                'delay_sooner',
                'amount_sooner',
                'choice',
            ),
            parameters=OrderedDict([
                ('k', (0, 0.1, 1)),
                ('beta', (0, 1, 5)),
            ]),
            regressors=OrderedDict([
                
            ]),
            postpreds=['y_pred'],
            parameters_desc=OrderedDict([
                ('k', 'discounting rate'),
                ('beta', 'inverse temperature'),
            ]),
            additional_args_desc=OrderedDict([
                
            ]),
            **kwargs,
        )

    _preprocess_func = dd_single_preprocess_func


def dd_hyperbolic_single(
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
    """Delay Discounting Task - Hyperbolic Model

    Individual Bayesian Modeling of the Delay Discounting Task 
    using Hyperbolic Model [Mazur1987]_ with the following parameters:
    "k" (discounting rate), "beta" (inverse temperature).

    

    
    .. [Mazur1987] Mazur, J. E. (1987). An adjustment procedure for studying delayed reinforcement.

    

    User data should contain the behavioral data-set of all subjects of interest for
    the current analysis. When loading from a file, the datafile should be a
    **tab-delimited** text file, whose rows represent trial-by-trial observations
    and columns represent variables.

    For the Delay Discounting Task, there should be 6 columns of data
    with the labels "subjID", "delay_later", "amount_later", "delay_sooner", "amount_sooner", "choice". It is not necessary for the columns to be
    in this particular order; however, it is necessary that they be labeled
    correctly and contain the information below:

    - "subjID": A unique identifier for each subject in the data-set.
    - "delay_later": An integer representing the delayed days for the later option (e.g. 1, 6, 28).
    - "amount_later": A floating point number representing the amount for the later option (e.g. 10.5, 13.4, 30.9).
    - "delay_sooner": An integer representing the delayed days for the sooner option (e.g. 0).
    - "amount_sooner": A floating point number representing the amount for the sooner option (e.g. 10).
    - "choice": If amount_later was selected, choice == 1; else if amount_sooner was selected, choice == 0.

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

        __ http://mc-stan.org/users/documentation/

    Parameters
    ----------
    data
        Data to be modeled. It should be given as a Pandas DataFrame object,
        a filepath for a data file, or ``"example"`` for example data.
        Data columns should be labeled as: "subjID", "delay_later", "amount_later", "delay_sooner", "amount_sooner", "choice".
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
        Include trial-level posterior predictive simulations in
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
        Not used for this model.

    Returns
    -------
    model_data
        An ``hbayesdm.TaskModel`` instance with the following components:

        - ``model``: String value that is the name of the model ('dd_hyperbolic_single').
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
        from hbayesdm.models import dd_hyperbolic_single

        # Run the model and store results in "output"
        output = dd_hyperbolic_single(data='example', niter=2000, nwarmup=1000, nchain=4, ncore=4)

        # Visually check convergence of the sampling chains (should look like "hairy caterpillars")
        output.plot(type='trace')

        # Plot posterior distributions of the hyper-parameters (distributions should be unimodal)
        output.plot()

        # Check Rhat values (all Rhat values should be less than or equal to 1.1)
        rhat(output, less=1.1)

        # Show the LOOIC and WAIC model fit estimates
        print_fit(output)
    """
    return DdHyperbolicSingle(
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
