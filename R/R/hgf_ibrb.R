#' @templateVar MODEL_FUNCTION hgf_ibrb
#' @templateVar CONTRIBUTOR \href{https://github.com/bugoverdose}{Jinwoo Jeong} <\email{jwjeong96@@gmail.com}>
#' @templateVar TASK_NAME 
#' @templateVar TASK_CODE 
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Hierarchical Bayesian version of the Hierarchical Gaussian Filter for binary inputs and binary responses
#' @templateVar MODEL_CODE hgf_ibrb
#' @templateVar MODEL_CITE (Mathys C, 2011; Mathys CD et al., 2014)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "trialNum", "inputs", "responses"
#' @templateVar PARAMETERS \code{kappa} (phasic volatility for coupling with higher level (for each levels from 2 to L-1)), \code{omega} (tonic volatility (for each levels from 2 to L-1)), \code{vartheta} (constant volatility (at the highest level L)), \code{zeta} (tendency to choose the response that corresponds with one\'s current belief)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS 
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{trialNum}{Nominal integer representing the trial number: 1, 2, ...}
#' @templateVar DETAILS_DATA_3 \item{inputs}{Integer value representing the input on that trial: 0 or 1.}
#' @templateVar DETAILS_DATA_4 \item{responses}{Integer value representing the subject's action chosen on that trial: 0 or 1.}
#' @templateVar LENGTH_ADDITIONAL_ARGS 6
#' @templateVar ADDITIONAL_ARGS_1 \item{L}{Total level of hierarchy. Defaults to minimum level of 3}
#' @templateVar ADDITIONAL_ARGS_2 \item{kappa_upper}{Upper bound for kappa parameters. Defaults to 2}
#' @templateVar ADDITIONAL_ARGS_3 \item{omega_upper}{Upper bound for omega parameters. Defaults to 5}
#' @templateVar ADDITIONAL_ARGS_4 \item{omega_lower}{Lower bound for omega parameters. Defaults to -5}
#' @templateVar ADDITIONAL_ARGS_5 \item{theta_upper}{Upper bound for theta parameter. Defaults to 2}
#' @templateVar ADDITIONAL_ARGS_6 \item{zeta_upper}{Upper bound for zeta parameter. Defaults to 3}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Mathys C, Daunizeau J, Friston KJ and Stephan KE (2011) A Bayesian foundation for individual learning under uncertainty. Front. Hum. Neurosci. 5:39. https://doi.org/10.3389/fnhum.2011.00039
#'
#' Mathys CD, Lomakina EI, Daunizeau J, Iglesias S, Brodersen KH, Friston KJ and Stephan KE (2014) Uncertainty in perception and the Hierarchical Gaussian Filter. Front. Hum. Neurosci. 8:825. https://doi.org/10.3389/fnhum.2014.00825
#'


hgf_ibrb <- hBayesDM_model(
  task_name       = "",
  model_name      = "hgf_ibrb",
  model_type      = "",
  data_columns    = c("subjID", "trialNum", "inputs", "responses"),
  parameters      = list(
    "kappa" = c(0, 0, Inf),
    "omega" = c(-Inf, 0, Inf),
    "vartheta" = c(0, 1, Inf),
    "zeta" = c(0, 1, Inf)
  ),
  regressors      = NULL,
  postpreds       = NULL,
  preprocess_func = hgf_ibrb_preprocess_func)
