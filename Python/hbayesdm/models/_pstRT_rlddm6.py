from typing import Sequence, Union, Any
from collections import OrderedDict

from numpy import Inf, exp
import pandas as pd

from hbayesdm.base import TaskModel
from hbayesdm.preprocess_funcs import pstRT_preprocess_func

__all__ = ['pstRT_rlddm6']


class PstrtRlddm6(TaskModel):
    def __init__(self, **kwargs):
        super().__init__(
            task_name='pstRT',
            model_name='rlddm6',
            model_type='',
            data_columns=(
                'subjID',
                'iter',
                'cond',
                'prob',
                'choice',
                'RT',
                'feedback',
            ),
            parameters=OrderedDict([
                ('a', (0, 1.6, Inf)),
                ('bp', (-0.3, 0.02, 0.3)),
                ('tau', (0, 0.2, Inf)),
                ('v', (-Inf, 2.8, Inf)),
                ('alpha_pos', (0, 0.04, 1)),
                ('alpha_neg', (0, 0.02, 1)),
            ]),
            regressors=OrderedDict([
                ('Q1', 2),
                ('Q2', 2),
            ]),
            postpreds=['choice_os', 'RT_os', 'choice_sm', 'RT_sm', 'fd_sm'],
            parameters_desc=OrderedDict([
                ('a', 'boundary separation'),
                ('bp', 'boundary separation power'),
                ('tau', 'non-decision time'),
                ('v', 'drift rate scaling'),
                ('alpha_pos', 'learning rate for positive prediction error'),
                ('alpha_neg', 'learning rate for negative prediction error'),
            ]),
            additional_args_desc=OrderedDict([
                ('RTbound', 0.1),
                ('initQ', 0.5),
            ]),
            **kwargs,
        )

    _preprocess_func = pstRT_preprocess_func


def pstRT_rlddm6(
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
    """Probabilistic Selection Task (with RT data) - Reinforcement Learning Drift Diffusion Model 6

    Hierarchical Bayesian Modeling of the Probabilistic Selection Task (with RT data) [Frank2007]_, [Frank2004]_
    using Reinforcement Learning Drift Diffusion Model 6 [Pedersen2017]_ with the following parameters:
    "a" (boundary separation), "bp" (boundary separation power), "tau" (non-decision time), "v" (drift rate scaling), "alpha_pos" (learning rate for positive prediction error), "alpha_neg" (learning rate for negative prediction error).

    

    .. [Frank2007] Frank, M. J., Santamaria, A., O'Reilly, R. C., & Willcutt, E. (2007). Testing computational models of dopamine and noradrenaline dysfunction in attention deficit/hyperactivity disorder. Neuropsychopharmacology, 32(7), 1583-1599.
    .. [Frank2004] Frank, M. J., Seeberger, L. C., & O'reilly, R. C. (2004). By carrot or by stick: cognitive reinforcement learning in parkinsonism. Science, 306(5703), 1940-1943.
    .. [Pedersen2017] Pedersen, M. L., Frank, M. J., & Biele, G. (2017). The drift diffusion model as the choice rule in reinforcement learning. Psychonomic bulletin & review, 24(4), 1234-1251.

    .. codeauthor:: Hoyoung Doh <hoyoung.doh@gmail.com>
    .. codeauthor:: Sanghoon Kang <sanghoon.kang@yale.edu>
    .. codeauthor:: Jihyun K. Hur <jihyun.hur@yale.edu>

    User data should contain the behavioral data-set of all subjects of interest for
    the current analysis. When loading from a file, the datafile should be a
    **tab-delimited** text file, whose rows represent trial-by-trial observations
    and columns represent variables.

    For the Probabilistic Selection Task (with RT data), there should be 7 columns of data
    with the labels "subjID", "iter", "cond", "prob", "choice", "RT", "feedback". It is not necessary for the columns to be
    in this particular order; however, it is necessary that they be labeled
    correctly and contain the information below:

    - "subjID": A unique identifier for each subject in the data-set.
    - "iter": Integer value representing the trial number for each task condition.
    - "cond": Integer value representing the task condition of the given trial (AB == 1, CD == 2, EF == 3).
    - "prob": Float value representing the probability that a correct response (1) is rewarded in the current task condition.
    - "choice": Integer value representing the option chosen on the given trial (1 or 2).
    - "RT": Float value representing the time taken for the response on the given trial.
    - "feedback": Integer value representing the outcome of the given trial (where 'correct' == 1, and 'incorrect' == 0).

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
        Data columns should be labeled as: "subjID", "iter", "cond", "prob", "choice", "RT", "feedback".
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
        Whether to export model-based regressors. For this model they are: "Q1", "Q2".
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
        For this model, it's possible to set the following model-specific argument to a value that you may prefer.

        - ``RTbound``: Floating point value representing the lower bound (i.e., minimum allowed) reaction time. Defaults to 0.1 (100 milliseconds).
        - ``initQ``: Floating point value representing the model's initial value of any choice.

    Returns
    -------
    model_data
        An ``hbayesdm.TaskModel`` instance with the following components:

        - ``model``: String value that is the name of the model ('pstRT_rlddm6').
        - ``all_ind_pars``: Pandas DataFrame containing the summarized parameter values
          (as specified by ``ind_pars``) for each subject.
        - ``par_vals``: OrderedDict holding the posterior samples over different parameters.
        - ``fit``: A PyStan StanFit object that contains the fitted Stan model.
        - ``raw_data``: Pandas DataFrame containing the raw data used to fit the model,
          as specified by the user.
        - ``model_regressor``: Dict holding the extracted model-based regressors.

    Examples
    --------

    .. code:: python

        from hbayesdm import rhat, print_fit
        from hbayesdm.models import pstRT_rlddm6

        # Run the model and store results in "output"
        output = pstRT_rlddm6(data='example', niter=2000, nwarmup=1000, nchain=4, ncore=4)

        # Visually check convergence of the sampling chains (should look like "hairy caterpillars")
        output.plot(type='trace')

        # Plot posterior distributions of the hyper-parameters (distributions should be unimodal)
        output.plot()

        # Check Rhat values (all Rhat values should be less than or equal to 1.1)
        rhat(output, less=1.1)

        # Show the LOOIC and WAIC model fit estimates
        print_fit(output)
    """
    return PstrtRlddm6(
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
