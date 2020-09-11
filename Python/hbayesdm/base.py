import multiprocessing
import os
import pickle
import warnings
from abc import ABCMeta, abstractmethod
from collections import OrderedDict
from pathlib import Path
from typing import Any, Callable, Dict, List, Sequence, Tuple, Union

import numpy as np
import pandas as pd
from scipy import stats

import arviz as az
import matplotlib.pyplot as plt
from pystan import StanModel
from pystan import __version__ as _pystan_version

__all__ = ['TaskModel']

PATH_ROOT = Path(__file__).absolute().parent
PATH_COMMON = PATH_ROOT / 'common'
PATH_STAN = (PATH_COMMON / 'stan_files').resolve()
PATH_EXTDATA = (PATH_COMMON / 'extdata').resolve()


class TaskModel(metaclass=ABCMeta):
    """hBayesDM TaskModel Base Class.

    The base class that is inherited by all hBayesDM task-models. Child classes
    should implement (i.e. override) the abstract method: `_preprocess_func`.
    """

    def __init__(self,
                 task_name: str,
                 model_name: str,
                 model_type: str,
                 data_columns: Sequence[str],
                 parameters: 'OrderedDict[str, Sequence[float]]',
                 regressors: 'OrderedDict[str, int]',
                 postpreds: Sequence[str],
                 parameters_desc: 'OrderedDict[str, str]',
                 additional_args_desc: 'OrderedDict[str, float]',
                 **kwargs):
        # Assign attributes
        self.__task_name = task_name
        self.__model_name = model_name
        self.__model_type = model_type
        self.__data_columns = data_columns
        self.__parameters = parameters
        self.__regressors = regressors
        self.__postpreds = postpreds
        self.__parameters_desc = parameters_desc
        self.__additional_args_desc = additional_args_desc

        # Handle special case (dd_single)
        if self.task_name == 'dd' and self.model_type == 'single':
            p = list(self.parameters_desc)[0]
            self.__parameters_desc['log' + p.upper()] = 'log(%s)' % p

        # Run model function
        model, all_ind_pars, par_vals, fit, raw_data, model_regressor \
            = self._run(**kwargs)

    @property
    def task_name(self) -> str:
        return self.__task_name

    @property
    def model_name(self) -> str:
        return self.__model_name

    @property
    def model_type(self) -> str:
        return self.__model_type

    @property
    def data_columns(self) -> Sequence[str]:
        return self.__data_columns

    @property
    def parameters(self) -> 'OrderedDict[str, Sequence[float]]':
        return self.__parameters

    @property
    def regressors(self) -> 'OrderedDict[str, int]':
        return self.__regressors

    @property
    def postpreds(self) -> Sequence[str]:
        return self.__postpreds

    @property
    def parameters_desc(self) -> 'OrderedDict[str, str]':
        return self.__parameters_desc

    @property
    def additional_args_desc(self) -> 'OrderedDict[str, float]':
        return self.__additional_args_desc

    @property
    def model(self) -> str:
        return self.__model

    @property
    def all_ind_pars(self) -> pd.DataFrame:
        return self.__all_ind_pars

    @property
    def par_vals(self) -> OrderedDict:
        return self.__par_vals

    @property
    def fit(self) -> Any:
        return self.__fit

    @property
    def raw_data(self) -> pd.DataFrame:
        return self.__raw_data

    @property
    def model_regressor(self) -> Dict:
        return self.__model_regressor

    def _run(self,
             data: pd.DataFrame = None,
             niter: int = 4000,
             nwarmup: int = 1000,
             nchain: int = 4,
             ncore: int = 1,
             nthin: int = 1,
             inits: Union[str, Sequence[float]] = 'random',
             ind_pars: str = 'mean',
             model_regressor: bool = False,
             vb: bool = False,
             inc_postpred: bool = False,
             adapt_delta: float = 0.95,
             stepsize: float = 1,
             max_treedepth: int = 10,
             **additional_args: Any) \
            -> Tuple[str, pd.DataFrame, OrderedDict, Any, Dict]:
        """Run the hbayesdm modeling function."""
        self._check_regressor(model_regressor)
        self._check_postpred(inc_postpred)

        raw_data, initial_columns = self._handle_data_args(data)
        insensitive_data_columns = self._get_insensitive_data_columns()

        self._check_data_columns(raw_data, insensitive_data_columns)
        self._check_missing_values(raw_data, insensitive_data_columns)

        general_info = self._prepare_general_info(raw_data)

        data_dict = self._preprocess_func(
            raw_data, general_info, additional_args)
        pars = self._prepare_pars(model_regressor, inc_postpred)

        n_subj = general_info['n_subj']
        if inits == 'vb':
            gen_init = self._prepare_gen_init_vb(data_dict, n_subj)
        else:
            gen_init = self._prepare_gen_init(inits, n_subj)

        model = self._get_model_full_name()
        ncore = self._set_number_of_cores(ncore)

        self._print_for_user(
            model, data, vb, nchain, ncore, niter, nwarmup,
            general_info, additional_args, model_regressor)

        sm = self._designate_stan_model(model)
        fit = self._fit_stan_model(
            vb, sm, data_dict, pars, gen_init, nchain, niter, nwarmup, nthin,
            adapt_delta, stepsize, max_treedepth, ncore)

        measure = self._define_measure_function(ind_pars)
        par_vals = self._extract_from_fit(fit, inc_postpred)
        all_ind_pars = self._measure_all_ind_pars(
            measure, par_vals, general_info['subjs'])
        model_regressor = self._extract_model_regressor(
            measure, par_vals) if model_regressor else None

        self._revert_initial_columns(raw_data, initial_columns)
        self._inform_completion()

        # Assign results as attributes
        self.__model = model
        self.__all_ind_pars = all_ind_pars
        self.__par_vals = par_vals
        self.__fit = fit
        self.__raw_data = raw_data
        self.__model_regressor = model_regressor

        return model, all_ind_pars, par_vals, fit, raw_data, model_regressor

    def _check_regressor(self, requested_by_user: bool):
        """Check if regressors are available for this model.

        Parameters
        ----------
        requested_by_user
            Whether model regressors are requested by user.
        """
        if requested_by_user and not self.regressors:
            raise RuntimeError(
                'Model-based regressors are not available for this model.')

    def _check_postpred(self, requested_by_user: bool):
        """Check if posterior predictive check is available for this model.

        Parameters
        ----------
        requested_by_user
            Whether PPC is requested by user.
        """
        if requested_by_user and not self.postpreds:
            raise RuntimeError(
                'Posterior predictions are not yet available for this model.')

    def _handle_data_args(self, data) -> Tuple[pd.DataFrame, List]:
        """Handle user data arguments and return raw_data.

        Parameters
        ----------
        data : Union[pandas.DataFrame, str]
            Pandas DataFrame object that holds the data.
            String of filepath for the data file.

        Returns
        -------
        raw_data : pandas.DataFrame
            Properly imported raw data as a Pandas DataFrame.
        initial_columns : List
            Initial column names of raw data, as given by the user.
        """
        if isinstance(data, pd.DataFrame):
            if not isinstance(data, pd.DataFrame):
                raise RuntimeError(
                    'Please provide `data` argument as a pandas.DataFrame.')
            raw_data = data

        elif isinstance(data, str):
            if data == "example":
                if self.model_type == '':
                    filename = '%s_exampleData.txt' % self.task_name
                else:
                    filename = '%s_%s_exampleData.txt' % (
                        self.task_name, self.model_type)

                example_data = PATH_EXTDATA / filename
                if not example_data.exists():
                    raise RuntimeError(
                        'Example data for this task does not exist.')
                raw_data = pd.read_csv(example_data, sep='\t')
            else:
                if data.endswith('.csv'):
                    raw_data = pd.read_csv(data)
                else:  # Read the file as a tsv format
                    raw_data = pd.read_csv(data, sep='\t')

        else:
            raise RuntimeError(
                'Invalid `data` argument given: ' + str(data))

        # Save initial column names of raw data for later
        initial_columns = list(raw_data.columns)

        # Assign case- & underscore-insensitive column names
        raw_data.columns = [
            col.replace('_', '').lower() for col in raw_data.columns]

        return raw_data, initial_columns

    def _get_insensitive_data_columns(self) -> List:
        """Return list of case- & underscore-insensitive data column names.

        Returns
        -------
        insensitive_data_columns
            List of data columns, with underscores removed and case ignored.
        """
        return [col.replace('_', '').lower() for col in self.data_columns]

    def _check_data_columns(self,
                            raw_data: pd.DataFrame,
                            insensitive_data_columns: List):
        """Check if necessary data columns all exist in raw data,
        while ignoring case and underscores in column names.

        Parameters
        ----------
        raw_data
            The raw behavioral data as a Pandas DataFrame.
        insensitive_data_columns
            Case- & underscore-insensitive data columns of this model.
        """
        if not set(insensitive_data_columns).issubset(set(raw_data.columns)):
            raise RuntimeError(
                'Data is missing one or more necessary data columns.\n' +
                'Necessary data columns are: ' + repr(self.data_columns))

    def _check_missing_values(self,
                              raw_data: pd.DataFrame,
                              insensitive_data_columns: List):
        """Remove rows containing NaNs in necessary columns.

        Parameters
        ----------
        raw_data
            The raw behavioral data as a Pandas DataFrame.
        insensitive_data_columns
            Case- & underscore-insensitive data columns of this model.
        """
        initial = raw_data.copy()
        raw_data.dropna(subset=insensitive_data_columns, inplace=True)
        nan_rows = set(initial.index).difference(raw_data.index)
        if nan_rows:
            print()
            print('Following rows of data have NaNs in necessary columns:')
            print(initial.loc[nan_rows, ])
            print('These rows are removed prior to modeling the data.')

    def _prepare_general_info(self, raw_data: pd.DataFrame) -> Dict:
        """Prepare general infos about the raw data.

        Parameters
        ----------
        raw_data
            The raw behavioral data as a Pandas DataFrame.

        Returns
        -------
        general_info : Dict
            'grouped_data': data grouped by subjs (& blocks) - Pandas GroupBy,
            'subjs': list of all subjects in data,
            'n_subj': total number of subjects in data,
            'b_subjs': number of blocks per subj,
            'b_max': max number of blocks across all subjs,
            't_subjs': number of trials (per block) per subj,
            't_max': max number of trials across all subjs (& blocks).
        """
        if self.model_type == '' or self.model_type == 'single':
            grouped_data = raw_data.groupby('subjid', sort=False)
            trials_per_subj = grouped_data.size()
            subjs = list(trials_per_subj.index)
            n_subj = len(subjs)
            t_subjs = list(trials_per_subj)
            t_max = max(t_subjs)
            b_subjs, b_max = None, None
            if self.model_type == 'single' and n_subj != 1:
                raise RuntimeError(
                    'More than 1 unique subjects exist in data, ' +
                    'while using \'single\' type model.')
        else:
            grouped_data = raw_data.groupby(['subjid', 'block'], sort=False)
            trials_per_block = grouped_data.size()
            subj_block = trials_per_block.index.to_frame(index=False)
            blocks_per_subj = subj_block.groupby('subjid', sort=False).size()
            subjs = list(blocks_per_subj.index)
            n_subj = len(subjs)
            b_subjs = list(blocks_per_subj)
            b_max = max(b_subjs)
            t_subjs = [list(trials_per_block[subj]) for subj in subjs]
            t_max = max(max(t_subjs))
        return {'grouped_data': grouped_data,
                'subjs': subjs, 'n_subj': n_subj,
                'b_subjs': b_subjs, 'b_max': b_max,
                't_subjs': t_subjs, 't_max': t_max}

    @abstractmethod
    def _preprocess_func(self,
                         raw_data: pd.DataFrame,
                         general_info: Dict,
                         additional_args: Dict) -> Dict:
        """Preprocess the raw data to pass to pystan.

        This function should be overridden in each specific model class.

        Parameters
        ----------
        raw_data
            The raw behavioral data as a Pandas DataFrame.
        general_info
            Holds general infos about the raw data.
        additional_args
            Optional additional argument(s) that may be used.

        Returns
        -------
        data_dict
            Will directly be passed to pystan.
        """
        pass

    def _prepare_pars(self, model_regressor: bool, inc_postpred: bool) -> List:
        """Prepare the parameters of interest for pystan.

        Parameters
        ----------
        model_regressor
            Whether user requested to extract model-based regressors.
        inc_postpred
            Whether user requested to include posterior predictive checks.

        Returns
        -------
        pars
            List of parameters of interest for pystan.
        """
        pars = []
        if self.model_type != 'single':
            pars += ['mu_' + p for p in self.parameters]
            pars += ['sigma']
        pars += self.parameters_desc
        pars += ['log_lik']
        if model_regressor:
            pars += self.regressors
        if inc_postpred:
            pars += self.postpreds
        return pars

    def _prepare_gen_init_vb(self,
                             data_dict: Dict,
                             n_subj: int,
                             ) -> Union[str, Callable]:
        """Prepare initial values for the parameters using Variational Bayesian
        methods.

        Parameters
        ----------
        data_dict
            Dict holding the data to pass to Stan.
        n_subj
            Total number of subjects in data.

        Returns
        -------
        gen_init : Union[str, Callable]
            A function that returns initial values for each parameter, based on
            the variational Bayesian method.
        """
        model = self._get_model_full_name()
        sm = self._designate_stan_model(model)

        try:
            fit = sm.vb(data=data_dict)
        except Exception:
            warnings.warn(
                'Failed to get VB estimates for initial values. '
                'Use random values for initial values.',
                RuntimeWarning, stacklevel=1)
            return 'random'

        len_param = len(self.parameters)
        dict_vb = dict(zip(fit['mean_par_names'], fit['mean_pars']))

        dict_init = {}
        if self.model_type == 'single':
            for p in self.parameters:
                dict_init[p] = dict_vb[p]
        else:
            dict_init['mu_pr'] = \
                [dict_vb['mu_pr[%d]' % (i + 1)] for i in range(len_param)]
            dict_init['sigma'] = \
                [dict_vb['sigma[%d]' % (i + 1)] for i in range(len_param)]
            for p in self.parameters:
                dict_init['%s_pr' % p] = \
                    [dict_vb['%s_pr[%d]' % (p, i + 1)] for i in range(n_subj)]

        def gen_init():
            return dict_init

        return gen_init

    def _prepare_gen_init(self,
                          inits: Union[str, Sequence[float]],
                          n_subj: int,
                          ) -> Union[str, Callable]:
        """Prepare initial values for the parameters.

        Parameters
        ----------
        inits
            User-defined inits. Can be the strings 'random' or 'fixed',
            or a list of float values to use as initial values for parameters.
        n_subj
            Total number of subjects in data.

        Returns
        -------
        gen_init : Union[str, Callable]
            Either a string 'random', or a function that returns a Dict
            holding the initial values for each parameter.
        """
        if inits == 'random':
            return 'random'

        if inits == 'fixed':
            inits = [plausible for _, plausible, _ in self.parameters.values()]
        elif len(inits) != len(self.parameters):
            raise RuntimeError(
                'Length of `inits` must be %d ' % len(self.parameters) +
                '(= the number of parameters of this model).')

        def gen_init():
            if self.model_type == 'single':
                return dict(zip(self.parameters, inits))
            else:
                def get_prime(v, lb, ub):
                    if np.isinf(lb):
                        return v
                    elif np.isinf(ub):
                        return np.log(v - lb)
                    else:
                        return stats.norm.ppf((v - lb) / (ub - lb))

                primes = [get_prime(inits[i], lb, ub) for i, (lb, _, ub) in
                          enumerate(self.parameters.values())]
                group_level = {'mu_pr': primes, 'sigma': [1.0] * len(primes)}
                indiv_level = {param + '_pr': [prime] * n_subj for
                               param, prime in zip(self.parameters, primes)}
                return {**group_level, **indiv_level}

        return gen_init

    def _get_model_full_name(self) -> str:
        """Return full name of model.

        Returns
        -------
        model
            Full name of the model.
        """
        if self.model_type == '':
            return '%s_%s' % (self.task_name, self.model_name)
        else:
            return '%s_%s_%s' % (
                self.task_name, self.model_name, self.model_type)

    def _set_number_of_cores(self, ncore: int) -> int:
        """Set number of cores for parallel computing.

        Parameters
        ----------
        ncore
            Number of cores to use, specified by user.

        Returns
        -------
        ncore
            Actual number of cores to use (value to be passed to pystan).
        """
        local_cores = multiprocessing.cpu_count()
        if ncore == -1 or ncore > local_cores:
            return local_cores
        return ncore

    def _print_for_user(self, model: str, data: pd.DataFrame, vb: bool,
                        nchain: int, ncore: int, niter: int, nwarmup: int,
                        general_info: Dict, additional_args: Dict,
                        model_regressor: bool):
        """Print information for user.

        Parameters
        ----------
        model
            Full name of model.
        data
            Pandas DataFrame object holding user data.
        vb
            Whether to use variational Bayesian analysis.
        nchain
            Number of chains to run.
        ncore
            Number of cores to use.
        niter
            Number of iterations per chain.
        nwarmup
            Number of warm-up iterations.
        general_info
            Dict holding general infos about the raw data.
        additional_args
            Optional additional arguments that may be used.
        model_regressor
            Whether to extract model-based regressors.
        """
        print()
        print('Model  =', model)
        if isinstance(data, pd.DataFrame):
            print('Data   = <pandas.DataFrame object>')
        else:
            print('Data   =', str(data))
        print()
        print('Details:')
        if vb:
            print(' Using variational inference')
        else:
            print(' # of chains                    =', nchain)
            print(' # of cores used                =', ncore)
            print(' # of MCMC samples (per chain)  =', niter)
            print(' # of burn-in samples           =', nwarmup)
        print(' # of subjects                  =', general_info['n_subj'])
        if self.model_type == 'multipleB':
            print(' # of (max) blocks per subject  =', general_info['b_max'])
        if self.model_type == '':
            print(' # of (max) trials per subject  =', general_info['t_max'])
        elif self.model_type == 'multipleB':
            print(' # of (max) trials...')
            print('      ...per block per subject  =', general_info['t_max'])
        else:  # (self.model_type == 'single')
            print(' # of trials (for this subject) =', general_info['t_max'])

        # Models with additional arguments
        if self.additional_args_desc:
            for arg, default_value in self.additional_args_desc.items():
                print(' `{}` is set to                '.format(arg)[:31],
                      '= {}'.format(additional_args.get(arg, default_value)))

        # When extracting model-based regressors
        if model_regressor:
            print()
            print('**************************************')
            print('**  Extract model-based regressors  **')
            print('**************************************')

        # An empty newline before Stan begins
        print()

    def _designate_stan_model(self, model: str) -> StanModel:
        """Designate the stan model to use for sampling.

        Parameters
        ----------
        model
            Full name of the model.

        Returns
        -------
        sm
            Compiled StanModel obj to use for sampling & fitting.
        """
        model_path = str(PATH_STAN / (model + '.stan'))
        cache_file = 'cached-%s-pystan_%s.pkl' % (model, _pystan_version)

        if os.path.exists(cache_file):
            try:
                with open(cache_file, 'rb') as cached_stan_model:
                    sm = pickle.load(cached_stan_model)
                with open(model_path, 'r') as model_stan_code:
                    assert sm.model_code == model_stan_code.read()
                does_exist = True
            except Exception:
                print('Invalid cached StanModel:', cache_file)
                print('Remove the cached model...')
                os.remove(cache_file)
                does_exist = False
        else:
            does_exist = False

        if does_exist:
            print('Using cached StanModel:', cache_file)
        else:
            sm = StanModel(file=model_path, model_name=model,
                           include_paths=[str(PATH_STAN)])
            with open(cache_file, 'wb') as f:
                pickle.dump(sm, f)

        return sm

    def _fit_stan_model(self, vb: bool, sm: StanModel, data_dict: Dict,
                        pars: List, gen_init: Union[str, Callable],
                        nchain: int, niter: int, nwarmup: int, nthin: int,
                        adapt_delta: float, stepsize: float,
                        max_treedepth: int, ncore: int) -> Any:
        """Fit the stan model.

        Parameters
        ----------
        vb
            Whether to perform variational Bayesian analysis.
        sm
            The StanModel object to use to fit the model.
        data_dict
            Dict holding the data to pass to Stan.
        pars
            List specifying the parameters of interest.
        gen_init
            String or function to specify how to generate the initial values.
        nchain
            Number of chains to run.
        niter
            Number of iterations per chain.
        nwarmup
            Number of warm-up iterations.
        nthin
            Use every `i == nthin` sample to generate posterior distribution.
        adapt_delta
            Advanced control argument for sampler.
        stepsize
            Advanced control argument for sampler.
        max_treedepth
            Advanced control argument for sampler.
        ncore
            Argument for parallel computing while sampling multiple chains.

        Returns
        -------
        fit
            The fitted result returned by `vb` or `sampling` function.
        """
        if vb:
            return sm.vb(data=data_dict,
                         pars=pars,
                         init=gen_init)
        else:
            return sm.sampling(data=data_dict,
                               pars=pars,
                               init=gen_init,
                               chains=nchain,
                               iter=niter,
                               warmup=nwarmup,
                               thin=nthin,
                               control={'adapt_delta': adapt_delta,
                                        'stepsize': stepsize,
                                        'max_treedepth': max_treedepth},
                               n_jobs=ncore)

    def _define_measure_function(self, ind_pars: str) -> Callable:
        """Define which function to use to summarize results.

        Parameters
        ----------
        ind_pars
            String specifying how to summarize results.

        Returns
        -------
        measure
            Function to use to summarize (measure) the results.
        """
        return {
            'mean': np.mean,
            'median': np.median,
            'mode': stats.mode,
        }[ind_pars]

    def _extract_from_fit(self, fit: Any, inc_postpred: bool) -> OrderedDict:
        """Extract from the stan fit object.

        Parameters
        ----------
        fit
            Fitted result of sampling the stan model.
        inc_postpred
            Whether user requested to include posterior predictive checks.

        Returns
        -------
        par_vals
            Entire raw draws of MCMC sampler, for each parameter (& subject).
        """
        par_vals = fit.extract(permuted=True)
        if inc_postpred:
            for pp in self.postpreds:
                par_vals[pp][par_vals[pp] == -1] = np.nan
        return par_vals

    def _measure_all_ind_pars(self,
                              measure: Callable,
                              par_vals: OrderedDict,
                              subjs: List) -> pd.DataFrame:
        """Measure all individual parameters (per subject).

        Parameters
        ----------
        measure
            Function to use to summarize the samples.
        par_vals
            Raw draws of MCMC sampler (per parameter & subject).
        subjs
            List of all the subjects in the data.

        Returns
        -------
        all_ind_pars
            Pandas DataFrame summarizing the draws per parameter (& subject).
        """
        # Define which parameters to measure
        which_pars = list(self.parameters_desc)

        # Measure all individual parameters
        if self.model_type == 'single':
            return pd.DataFrame(
                {p: measure(par_vals[p]) for p in which_pars},
                index=subjs
            )
        else:
            return pd.DataFrame(
                {p: list(map(measure, par_vals[p].T)) for p in which_pars},
                index=subjs
            )

    def _extract_model_regressor(
            self, measure: Callable, par_vals: OrderedDict) -> Dict:
        """Model regressors (for model-based neuroimaging, etc.).

        Parameters
        ----------
        measure
            Function to use to summarize the samples.
        par_vals
            Raw draws of MCMC sampler.

        Returns
        -------
        model_regressor
            Dict containing summarized model regressor values.
        """
        return {r: np.apply_over_axes(
            measure,
            par_vals[r],
            [i + 1 for i in range(dim_size)]
        ).squeeze() for r, dim_size in self.regressors.items()}

    def _revert_initial_columns(self,
                                raw_data: pd.DataFrame,
                                initial_columns: List):
        """Give back initial column names of raw data.

        Parameters
        ----------
        raw_data
            Data used to fit the model, as specified by the user.
        initial_columns
            Initial column names of raw data, as given by the user.
        """
        print(raw_data.columns)
        print(initial_columns)
        raw_data.columns = initial_columns

    def _inform_completion(self):
        """Inform user of completion."""
        print('************************************')
        print('**** Model fitting is complete! ****')
        print('************************************')

    def __str__(self):
        return self.fit.stansummary()

    def plot(self,
             type: str = 'dist',
             credible_interval: float = 0.94,
             point_estimate: str = 'mean',
             bins: Union[int, Sequence, str] = 'auto',
             round_to: int = 2,
             **kwargs):
        """General purpose plotting for hbayesdm-py.

        This function plots hyper-parameters.

        Parameters
        ----------
        type
            Current options are: 'dist', 'trace'. Defaults to 'dist'.
        credible_interval
            Credible interval to plot. Defaults to 0.94.
        point_estimate
            Show point estimate on plot.
            Options are: 'mean', 'median' or 'mode'. Defaults to 'mean'.
        bins
            Controls the number of bins. Defaults to 'auto'.
            Accepts the same values (or keywords) as plt.hist() does.
        round_to
            Controls formatting for floating point numbers. Defaults to 2.
        **kwargs
            Passed as-is to plt.hist().
        """
        type_options = ('dist', 'trace')
        if type not in type_options:
            raise RuntimeError(
                'Plot type must be one of ' + repr(type_options))

        if self.model_type == 'single':
            var_names = list(self.parameters_desc)
        else:
            var_names = ['mu_' + p for p in self.parameters_desc]

        if type == 'dist':
            kwargs.setdefault('color', 'black')
            axes = az.plot_posterior(self.fit,
                                     kind='hist',
                                     var_names=var_names,
                                     credible_interval=credible_interval,
                                     point_estimate=point_estimate,
                                     bins=bins,
                                     round_to=round_to,
                                     **kwargs)
            for ax, (p, desc) in zip(axes, self.parameters_desc.items()):
                ax.set_title('{} ({})'.format(p, desc))
        elif type == 'trace':
            az.plot_trace(self.fit, var_names=var_names)

        plt.show()

    def plot_ind(self,
                 var_names: Union[str, List[str]] = None,
                 show_density: bool = True,
                 credible_interval: float = 0.94):
        """Plots individual posterior distributions, using ArviZ.

        Parameters
        ----------
        var_names
            Parameter(s) to plot. If not specified, show all model parameters.
        show_density
            Whether to show density. True or False. Defaults to True.
        credible_interval
            Credible interval to plot. Defaults to 0.94.
        """
        if var_names is None:
            var_names = list(self.parameters_desc)

        if show_density:
            kind = 'ridgeplot'
        else:
            kind = 'forestplot'

        az.plot_forest(self.fit,
                       kind=kind,
                       var_names=var_names,
                       credible_interval=credible_interval,
                       combined=True,
                       colors='gray', ridgeplot_alpha=0.8)
        plt.show()
