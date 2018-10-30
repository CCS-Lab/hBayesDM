#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4bandit2arm_delta_mod) {


    class_<rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> >("model_bandit2arm_delta")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_bandit2arm_delta_namespace::model_bandit2arm_delta, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4bandit4arm2_kalman_filter_mod) {


    class_<rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> >("model_bandit4arm2_kalman_filter")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_bandit4arm2_kalman_filter_namespace::model_bandit4arm2_kalman_filter, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4bandit4arm_4par_mod) {


    class_<rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> >("model_bandit4arm_4par")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_bandit4arm_4par_namespace::model_bandit4arm_4par, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4bandit4arm_lapse_mod) {


    class_<rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> >("model_bandit4arm_lapse")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_bandit4arm_lapse_namespace::model_bandit4arm_lapse, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4bart_par4_mod) {


    class_<rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> >("model_bart_par4")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_bart_par4_namespace::model_bart_par4, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4choiceRT_ddm_mod) {


    class_<rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> >("model_choiceRT_ddm")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_choiceRT_ddm_namespace::model_choiceRT_ddm, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4choiceRT_ddm_single_mod) {


    class_<rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> >("model_choiceRT_ddm_single")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_choiceRT_ddm_single_namespace::model_choiceRT_ddm_single, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4choiceRT_lba_mod) {


    class_<rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> >("model_choiceRT_lba")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_choiceRT_lba_namespace::model_choiceRT_lba, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4choiceRT_lba_single_mod) {


    class_<rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> >("model_choiceRT_lba_single")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_choiceRT_lba_single_namespace::model_choiceRT_lba_single, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4cra_exp_mod) {


    class_<rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> >("model_cra_exp")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_cra_exp_namespace::model_cra_exp, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4cra_linear_mod) {


    class_<rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> >("model_cra_linear")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_cra_linear_namespace::model_cra_linear, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4dd_cs_mod) {


    class_<rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> >("model_dd_cs")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_dd_cs_namespace::model_dd_cs, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4dd_cs_single_mod) {


    class_<rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> >("model_dd_cs_single")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_dd_cs_single_namespace::model_dd_cs_single, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4dd_exp_mod) {


    class_<rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> >("model_dd_exp")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_dd_exp_namespace::model_dd_exp, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4dd_hyperbolic_mod) {


    class_<rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> >("model_dd_hyperbolic")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_dd_hyperbolic_namespace::model_dd_hyperbolic, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4dd_hyperbolic_single_mod) {


    class_<rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> >("model_dd_hyperbolic_single")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_dd_hyperbolic_single_namespace::model_dd_hyperbolic_single, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4gng_m1_mod) {


    class_<rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> >("model_gng_m1")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_gng_m1_namespace::model_gng_m1, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4gng_m1_reg_mod) {


    class_<rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> >("model_gng_m1_reg")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_gng_m1_reg_namespace::model_gng_m1_reg, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4gng_m2_mod) {


    class_<rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> >("model_gng_m2")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_gng_m2_namespace::model_gng_m2, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4gng_m2_reg_mod) {


    class_<rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> >("model_gng_m2_reg")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_gng_m2_reg_namespace::model_gng_m2_reg, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4gng_m3_mod) {


    class_<rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> >("model_gng_m3")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_gng_m3_namespace::model_gng_m3, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4gng_m3_reg_mod) {


    class_<rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> >("model_gng_m3_reg")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_gng_m3_reg_namespace::model_gng_m3_reg, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4gng_m4_mod) {


    class_<rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> >("model_gng_m4")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_gng_m4_namespace::model_gng_m4, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4gng_m4_reg_mod) {


    class_<rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> >("model_gng_m4_reg")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_gng_m4_reg_namespace::model_gng_m4_reg, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4igt_orl_mod) {


    class_<rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> >("model_igt_orl")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_igt_orl_namespace::model_igt_orl, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4igt_pvl_decay_mod) {


    class_<rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> >("model_igt_pvl_decay")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_igt_pvl_decay_namespace::model_igt_pvl_decay, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4igt_pvl_delta_mod) {


    class_<rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> >("model_igt_pvl_delta")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_igt_pvl_delta_namespace::model_igt_pvl_delta, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4igt_vpp_mod) {


    class_<rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> >("model_igt_vpp")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_igt_vpp_namespace::model_igt_vpp, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4peer_ocu_mod) {


    class_<rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> >("model_peer_ocu")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_peer_ocu_namespace::model_peer_ocu, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4prl_ewa_mod) {


    class_<rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> >("model_prl_ewa")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_prl_ewa_namespace::model_prl_ewa, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4prl_fictitious_mod) {


    class_<rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> >("model_prl_fictitious")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_prl_fictitious_namespace::model_prl_fictitious, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4prl_fictitious_multipleB_mod) {


    class_<rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> >("model_prl_fictitious_multipleB")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_prl_fictitious_multipleB_namespace::model_prl_fictitious_multipleB, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4prl_fictitious_rp_mod) {


    class_<rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> >("model_prl_fictitious_rp")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_prl_fictitious_rp_namespace::model_prl_fictitious_rp, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4prl_fictitious_rp_woa_mod) {


    class_<rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> >("model_prl_fictitious_rp_woa")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_prl_fictitious_rp_woa_namespace::model_prl_fictitious_rp_woa, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4prl_fictitious_woa_mod) {


    class_<rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> >("model_prl_fictitious_woa")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_prl_fictitious_woa_namespace::model_prl_fictitious_woa, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4prl_rp_mod) {


    class_<rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> >("model_prl_rp")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_prl_rp_namespace::model_prl_rp, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4prl_rp_multipleB_mod) {


    class_<rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> >("model_prl_rp_multipleB")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_prl_rp_multipleB_namespace::model_prl_rp_multipleB, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4pst_gainloss_Q_mod) {


    class_<rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> >("model_pst_gainloss_Q")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_pst_gainloss_Q_namespace::model_pst_gainloss_Q, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4ra_noLA_mod) {


    class_<rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> >("model_ra_noLA")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_ra_noLA_namespace::model_ra_noLA, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4ra_noRA_mod) {


    class_<rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> >("model_ra_noRA")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_ra_noRA_namespace::model_ra_noRA, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4ra_prospect_mod) {


    class_<rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> >("model_ra_prospect")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_ra_prospect_namespace::model_ra_prospect, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4rdt_happiness_mod) {


    class_<rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> >("model_rdt_happiness")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_rdt_happiness_namespace::model_rdt_happiness, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4ts_par4_mod) {


    class_<rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> >("model_ts_par4")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_ts_par4_namespace::model_ts_par4, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4ts_par6_mod) {


    class_<rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> >("model_ts_par6")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_ts_par6_namespace::model_ts_par6, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4ts_par7_mod) {


    class_<rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> >("model_ts_par7")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_ts_par7_namespace::model_ts_par7, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4ug_bayes_mod) {


    class_<rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> >("model_ug_bayes")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_ug_bayes_namespace::model_ug_bayes, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4ug_delta_mod) {


    class_<rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> >("model_ug_delta")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_ug_delta_namespace::model_ug_delta, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
#include <Rcpp.h>
using namespace Rcpp ;
#include "include/models.hpp"

RCPP_MODULE(stan_fit4wcs_sql_mod) {


    class_<rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> >("model_wcs_sql")

    .constructor<SEXP,SEXP>()


    .method("call_sampler", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::call_sampler)
    .method("param_names", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::param_names)
    .method("param_names_oi", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::param_names_oi)
    .method("param_fnames_oi", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::param_fnames_oi)
    .method("param_dims", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::param_dims)
    .method("param_dims_oi", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::param_dims_oi)
    .method("update_param_oi", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::update_param_oi)
    .method("param_oi_tidx", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::param_oi_tidx)
    .method("grad_log_prob", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::grad_log_prob)
    .method("log_prob", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::log_prob)
    .method("unconstrain_pars", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::unconstrain_pars)
    .method("constrain_pars", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::constrain_pars)
    .method("num_pars_unconstrained", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::num_pars_unconstrained)
    .method("unconstrained_param_names", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::unconstrained_param_names)
    .method("constrained_param_names", &rstan::stan_fit<model_wcs_sql_namespace::model_wcs_sql, boost::random::ecuyer1988> ::constrained_param_names)
    ;
}
