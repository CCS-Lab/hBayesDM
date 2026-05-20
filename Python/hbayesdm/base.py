import multiprocessing
import re
import warnings
from abc import ABCMeta, abstractmethod
from collections import OrderedDict
from pathlib import Path
from typing import Any, Callable, Dict, List, Sequence, Tuple, Union

import arviz as az
import cmdstanpy
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
from scipy import stats

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
                 additional_args: 'OrderedDict[str, Any]',
                 additional_args_desc: 'OrderedDict[str, str]',
                 **kwargs):
        self.__task_name = task_name
        self.__model_name = model_name
        self.__model_type = model_type
        self.__data_columns = data_columns
        self.__parameters = parameters
        self.__regressors = regressors
        self.__postpreds = postpreds
        self.__parameters_desc = parameters_desc
        self.__additional_args = additional_args
        self.__additional_args_desc = additional_args_desc

        # Handle special case (dd_single)
        if self.task_name == 'dd' and self.model_type == 'single':
            p = list(self.parameters_desc)[0]
            self.__parameters_desc['log' + p.upper()] = 'log(%s)' % p

        self._run(**kwargs)

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
    def additional_args(self) -> 'OrderedDict[str, Any]':
        return self.__additional_args

    @property
    def additional_args_desc(self) -> 'OrderedDict[str, str]':
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
        """The CmdStanMCMC or CmdStanVB fit object."""
        return self.__fit

    @property
    def idata(self) -> Any:
        """ArviZ ``DataTree`` built lazily from the fit.

        For VB fits, only the ``posterior`` group is populated and convergence
        diagnostics like ``rhat`` are not meaningful.
        """
        if self.__idata is None:
            if self.__vb:
                # mean=False returns the variational *sample* (n_draws, *dims)
                # rather than the variational mean.
                vb_samples = self.__fit.stan_variables(mean=False)
                self.__idata = az.from_dict(
                    {'posterior': {p: np.expand_dims(np.asarray(v), axis=0)
                                   for p, v in vb_samples.items()}}
                )
            else:
                self.__idata = az.from_cmdstanpy(
                    posterior=self.__fit,
                    log_likelihood='log_lik',
                )
        return self.__idata

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
             **additional_args: Any) -> None:
        """Run the hbayesdm modeling function."""
        self._check_regressor(model_regressor)
        self._check_postpred(inc_postpred)

        raw_data, initial_columns = self._handle_data_args(data)
        insensitive_data_columns = self._get_insensitive_data_columns()

        self._check_data_columns(raw_data, insensitive_data_columns)
        self._check_missing_values(raw_data, insensitive_data_columns)

        general_info = self._prepare_general_info(raw_data)
        for key, value in self.__additional_args.items():
            if key not in additional_args:
                additional_args[key] = value

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
            vb, sm, data_dict, gen_init, nchain, niter, nwarmup, nthin,
            adapt_delta, stepsize, max_treedepth, ncore)

        measure = self._define_measure_function(ind_pars)
        par_vals = self._extract_from_fit(fit, pars, vb, inc_postpred)
        all_ind_pars = self._measure_all_ind_pars(
            measure, par_vals, general_info['subjs'])
        regressor_summary = self._extract_model_regressor(
            measure, par_vals) if model_regressor else None

        self._revert_initial_columns(raw_data, initial_columns)
        self._inform_completion()

        self.__model = model
        self.__all_ind_pars = all_ind_pars
        self.__par_vals = par_vals
        self.__fit = fit
        self.__vb = vb
        self.__idata = None
        self.__raw_data = raw_data
        self.__model_regressor = regressor_summary

    def _check_regressor(self, requested_by_user: bool):
        if requested_by_user and not self.regressors:
            raise RuntimeError(
                'Model-based regressors are not available for this model.')

    def _check_postpred(self, requested_by_user: bool):
        if requested_by_user and not self.postpreds:
            raise RuntimeError(
                'Posterior predictions are not yet available for this model.')

    def _handle_data_args(self, data) -> Tuple[pd.DataFrame, List]:
        if isinstance(data, pd.DataFrame):
            raw_data = data
        elif isinstance(data, str):
            if data == "example":
                filename = "exampleData.txt"
                if len(self.model_type) > 0:
                    filename = f"{self.model_type}_{filename}"
                if len(self.task_name) > 0:
                    filename = f"{self.task_name}_{filename}"
                else:
                    filename = f"{self.model_name}_{filename}"

                example_data = PATH_EXTDATA / filename
                if not example_data.exists():
                    raise RuntimeError(
                        'Example data for this task does not exist.')
                raw_data = pd.read_csv(example_data, sep='\t')
            else:
                if data.endswith('.csv'):
                    raw_data = pd.read_csv(data)
                else:
                    raw_data = pd.read_csv(data, sep='\t')
        else:
            raise RuntimeError(
                'Invalid `data` argument given: ' + str(data))

        initial_columns = list(raw_data.columns)
        raw_data.columns = [
            col.replace('_', '').lower() for col in raw_data.columns]
        return raw_data, initial_columns

    def _get_insensitive_data_columns(self) -> List:
        return [col.replace('_', '').lower() for col in self.data_columns]

    def _check_data_columns(self, raw_data, insensitive_data_columns):
        if not set(insensitive_data_columns).issubset(set(raw_data.columns)):
            raise RuntimeError(
                'Data is missing one or more necessary data columns.\n' +
                'Necessary data columns are: ' + repr(self.data_columns))

    def _check_missing_values(self, raw_data, insensitive_data_columns):
        initial = raw_data.copy()
        raw_data.dropna(subset=insensitive_data_columns, inplace=True)
        nan_rows = set(initial.index).difference(raw_data.index)
        if nan_rows:
            print()
            print('Following rows of data have NaNs in necessary columns:')
            print(initial.loc[nan_rows, ])
            print('These rows are removed prior to modeling the data.')

    def _prepare_general_info(self, raw_data: pd.DataFrame) -> Dict:
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
                    'More than 1 unique subjects exist in data, '
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
    def _preprocess_func(self, raw_data, general_info, additional_args) -> Dict:
        """Preprocess raw data into the dict passed to Stan. Override per model."""

    def _prepare_pars(self, model_regressor: bool, inc_postpred: bool) -> List:
        pars = []
        if self.model_type != 'single':
            pars += ['mu_' + p for p in self.parameters]
            pars += ['sigma']
        pars += list(self.parameters_desc)
        if self.model_name == "dd" and self.model_type == 'single':
            pars += ['log' + list(self.parameters)[0].upper()]
        if self.model_name == "hgf_ibrb" and self.model_type == 'single':
            pars += ['logit_' + p for p in self.parameters]
        pars += ['log_lik']
        if model_regressor:
            pars += list(self.regressors)
        if inc_postpred:
            pars += list(self.postpreds)
        return pars

    def _prepare_gen_init_vb(self, data_dict: Dict, n_subj: int) -> Union[str, Callable]:
        model = self._get_model_full_name()
        sm = self._designate_stan_model(model)

        try:
            fit = sm.variational(data=data_dict)
        except Exception:
            warnings.warn(
                'Failed to get VB estimates for initial values. '
                'Use random values for initial values.',
                RuntimeWarning, stacklevel=1)
            return 'random'

        # cmdstanpy returns variational means via stan_variables()
        dict_vb = {k: np.asarray(v) for k, v in fit.stan_variables().items()}

        dict_init: Dict[str, Any] = {}
        if self.model_type == 'single':
            for p in self.parameters:
                dict_init[p] = dict_vb[p]
        else:
            dict_init['mu_pr'] = dict_vb['mu_pr']
            dict_init['sigma'] = dict_vb['sigma']
            for p in self.parameters:
                dict_init[f"{p}_pr"] = dict_vb[f"{p}_pr"]

        def gen_init():
            return dict_init

        return gen_init

    def _prepare_gen_init(self, inits, n_subj: int) -> Union[str, Callable]:
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

                primes = [get_prime(inits[i], lb, ub) for i, (lb, _, ub)
                          in enumerate(self.parameters.values())]
                group_level = {'mu_pr': primes, 'sigma': [1.0] * len(primes)}
                indiv_level = {param + '_pr': [prime] * n_subj for
                               param, prime in zip(self.parameters, primes)}
                return {**group_level, **indiv_level}

        return gen_init

    def _get_model_full_name(self) -> str:
        parts = [p for p in (self.task_name, self.model_name, self.model_type)
                 if p]
        return "_".join(parts)

    def _set_number_of_cores(self, ncore: int) -> int:
        local_cores = multiprocessing.cpu_count()
        if ncore == -1 or ncore > local_cores:
            return local_cores
        return ncore

    def _print_for_user(self, model, data, vb, nchain, ncore, niter, nwarmup,
                        general_info, additional_args, model_regressor):
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
        else:
            print(' # of trials (for this subject) =', general_info['t_max'])

        if additional_args:
            for arg, default_value in additional_args.items():
                print(' `{}` is set to                '.format(arg)[:31],
                      '= {}'.format(additional_args.get(arg, default_value)))

        if model_regressor:
            print()
            print('**************************************')
            print('**  Extract model-based regressors  **')
            print('**************************************')

        print()

    def _designate_stan_model(self, model: str) -> cmdstanpy.CmdStanModel:
        """Compile the Stan model via cmdstanpy.

        cmdstanpy caches the compiled binary alongside the .stan file.
        """
        model_path = PATH_STAN / (model + '.stan')
        if not model_path.exists():
            raise FileNotFoundError(f"Stan file not found: {model_path}")
        return cmdstanpy.CmdStanModel(
            model_name=model,
            stan_file=str(model_path),
            stanc_options={'include-paths': [str(PATH_STAN)]},
        )

    def _fit_stan_model(self, vb: bool, sm: cmdstanpy.CmdStanModel,
                        data_dict: Dict,
                        gen_init: Union[str, Callable],
                        nchain: int, niter: int, nwarmup: int, nthin: int,
                        adapt_delta: float, stepsize: float,
                        max_treedepth: int, ncore: int) -> Any:
        inits = self._resolve_inits(gen_init, nchain)

        if vb:
            # cmdstanpy's variational() takes inits only as a perturbation
            # scale (Optional[float]); dict inits are not supported.
            return sm.variational(data=data_dict)

        iter_sampling = max(1, niter - nwarmup)
        return sm.sample(
            data=data_dict,
            chains=nchain,
            parallel_chains=ncore,
            iter_warmup=nwarmup,
            iter_sampling=iter_sampling,
            thin=nthin,
            adapt_delta=adapt_delta,
            step_size=stepsize,
            max_treedepth=max_treedepth,
            inits=inits,
            show_progress=False,
        )

    @staticmethod
    def _resolve_inits(gen_init, nchain: int):
        if gen_init == 'random' or gen_init is None:
            return None
        if callable(gen_init):
            # cmdstanpy accepts a list of dicts (one per chain) or a single dict
            return [gen_init() for _ in range(nchain)]
        return gen_init

    def _define_measure_function(self, ind_pars: str) -> Callable:
        return {
            'mean': np.mean,
            'median': np.median,
            'mode': stats.mode,
        }[ind_pars]

    def _extract_from_fit(self, fit: Any, pars: List[str],
                          vb: bool, inc_postpred: bool) -> OrderedDict:
        """Extract requested parameters from a cmdstanpy fit.

        For MCMC, returns draws merged across chains: shape (n_draws, *param_dims).
        For VB, returns the variational mean as a single array (no draw dim).
        """
        all_vars = fit.stan_variables()
        par_vals: OrderedDict = OrderedDict()
        for p in pars:
            if p in all_vars:
                par_vals[p] = np.asarray(all_vars[p])
        if inc_postpred:
            for pp in self.postpreds:
                if pp in par_vals:
                    arr = par_vals[pp].astype(float)
                    arr[arr == -1] = np.nan
                    par_vals[pp] = arr
        return par_vals

    def _measure_all_ind_pars(self, measure: Callable, par_vals: OrderedDict,
                              subjs: List) -> pd.DataFrame:
        which_pars = list(self.parameters_desc)

        if self.model_type == 'single':
            cols = {}
            for p in which_pars:
                a = np.asarray(par_vals[p])
                if a.ndim == 1:
                    cols[p] = measure(a)
                else:
                    flat = a.reshape(a.shape[0], -1)
                    for i in range(flat.shape[1]):
                        cols[f"{p}[{i+1}]"] = measure(flat[:, i])
            return pd.DataFrame([cols], index=subjs)

        N = len(subjs)
        cols: Dict[str, Any] = {}
        for p in which_pars:
            a = np.asarray(par_vals[p])
            if a.ndim == 1:
                cols[p] = np.repeat(measure(a), N)
            elif a.ndim == 2:
                cols[p] = measure(a, axis=0)
            elif a.ndim == 3:
                vals = measure(a, axis=0)
                K = vals.shape[1]
                for j in range(K):
                    cols[f"{p}[{j+1}]"] = vals[:, j]
            else:
                raise ValueError(f"Unexpected ndim for {p}: {a.ndim}")
        return pd.DataFrame(cols, index=subjs)

    def _extract_model_regressor(self, measure: Callable,
                                 par_vals: OrderedDict) -> Dict:
        return {r: np.apply_over_axes(
            measure,
            par_vals[r],
            [i + 1 for i in range(dim_size)]
        ).squeeze() for r, dim_size in self.regressors.items()}

    def _revert_initial_columns(self, raw_data: pd.DataFrame,
                                initial_columns: List):
        raw_data.columns = initial_columns

    def _inform_completion(self):
        print('************************************')
        print('**** Model fitting is complete! ****')
        print('************************************')

    def __str__(self):
        try:
            return str(self.fit.summary())
        except Exception:
            return repr(self.fit)

    def plot(self,
             type: str = 'dist',
             ci_prob: float = 0.95,
             point_estimate: str = 'mean',
             **kwargs):
        """Plot hyper-parameter distributions or traces.

        For hierarchical models, the group-level ``mu_*`` parameters are
        plotted; for ``single`` models, the individual parameters themselves.

        Parameters
        ----------
        type : {'dist', 'trace'}
            ``'dist'`` plots posterior densities with a credible interval and
            point estimate (via ``arviz.plot_dist``). ``'trace'`` plots MCMC
            traces alongside marginal densities (via ``arviz.plot_trace``).
        ci_prob : float
            Credible interval probability mass for ``type='dist'``. Defaults
            to 0.95.
        point_estimate : {'mean', 'median', 'mode'} or None
            Which posterior point estimate to mark on density plots. Set to
            ``None`` to omit. Only applies when ``type='dist'``.
        **kwargs
            Forwarded to the underlying arviz plotting function.

        Raises
        ------
        RuntimeError
            If ``type`` is not one of the supported options.
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
            az.plot_dist(self.idata,
                         var_names=var_names,
                         ci_prob=ci_prob,
                         point_estimate=point_estimate,
                         **kwargs)
        elif type == 'trace':
            az.plot_trace(self.idata, var_names=var_names, **kwargs)

        plt.show()

    def plot_ind(self,
                 var_names: Union[str, List[str]] = None,
                 ci_prob: float = 0.95,
                 **kwargs):
        """Plot per-subject posterior summaries via ``arviz.plot_forest``.

        Renders a forest plot with one row per subject for each requested
        parameter, showing posterior intervals so that individual differences
        can be compared at a glance.

        Parameters
        ----------
        var_names
            Parameter name(s) to plot. Defaults to all individual-level
            parameters (``self.parameters_desc``).
        ci_prob
            Outer credible interval probability mass. The inner interval is
            fixed at 0.5 (IQR-like). Defaults to 0.95.
        **kwargs
            Forwarded to ``arviz.plot_forest``.
        """
        if var_names is None:
            var_names = list(self.parameters_desc)

        # plot_forest draws both an inner and outer interval; fix the inner at
        # 0.5 (IQR-ish) and let the caller control the outer band.
        az.plot_forest(self.idata,
                       var_names=var_names,
                       ci_probs=[0.5, ci_prob],
                       combined=True,
                       **kwargs)
        plt.show()
