#' @templateVar MODEL_FUNCTION hgf_ibrb
#' @templateVar CONTRIBUTOR \href{https://github.com/bugoverdose}{Jinwoo Jeong} <\email{jwjeong96@@gmail.com}>
#' @templateVar TASK_NAME 
#' @templateVar TASK_CODE 
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Hierarchical Bayesian version of the Hierarchical Gaussian Filter model for binary inputs and binary responses
#' @templateVar MODEL_CODE hgf_ibrb
#' @templateVar MODEL_CITE (Mathys C, 2011; Mathys CD et al., 2014)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "trialNum", "u", "y"
#' @templateVar PARAMETERS \code{kappa} (phasic volatility for coupling with higher level for each level (2 ~ L-1)), \code{omega} (tonic volatility for each level (2 ~ L)), \code{zeta} (inverse decision noise, the tendency to choose the response that corresponds with one\'s current belief)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS 
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{trialNum}{Nominal integer representing the trial number: 1, 2, ...}
#' @templateVar DETAILS_DATA_3 \item{u}{Integer value representing the input on that trial: 0 or 1.}
#' @templateVar DETAILS_DATA_4 \item{y}{Integer value representing the subject's choice on that trial: 0 or 1.}
#' @templateVar LENGTH_ADDITIONAL_ARGS 10
#' @templateVar ADDITIONAL_ARGS_1 \item{L}{Total level of hierarchy. Defaults to minimum level of 3}
#' @templateVar ADDITIONAL_ARGS_2 \item{input_first}{TRUE if participant observed u[t] before choosing y[t], FALSE if participant observed u[t] after choosing y[t]}
#' @templateVar ADDITIONAL_ARGS_3 \item{mu0}{prior belief for each level before starting the experiment}
#' @templateVar ADDITIONAL_ARGS_4 \item{sigma0}{prior uncertainty for each level before starting the experiment}
#' @templateVar ADDITIONAL_ARGS_5 \item{kappa_lower}{Lower bounds for kappa for each level (2 ~ L-1). Defaults to [0] and can not be negative. Parameter value is fixed for level l if kappa_upper[l] == kappa_lower[l].}
#' @templateVar ADDITIONAL_ARGS_6 \item{kappa_upper}{Upper bounds for kappa for each level (2 ~ L-1). Defaults to [3]. Parameter value is fixed for level l if kappa_upper[l] == kappa_lower[l].}
#' @templateVar ADDITIONAL_ARGS_7 \item{omega_lower}{Lower bounds for omega for each level (2 ~ L). Defaults to [-10. -15]. Parameter value is fixed for level l if omega_upper[l] == omega_lower[l].}
#' @templateVar ADDITIONAL_ARGS_8 \item{omega_upper}{Upper bounds for omega for each level (2 ~ L). Defaults to [5, 5]. Parameter value is fixed for level l if omega_upper[l] == omega_lower[l].}
#' @templateVar ADDITIONAL_ARGS_9 \item{zeta_lower}{Upper bound for zeta. Defaults to 0 and can not be negative. Parameter value is fixed if zeta_lower == zeta_upper.}
#' @templateVar ADDITIONAL_ARGS_10 \item{zeta_upper}{Upper bound for zeta. Defaults to 3. Parameter value is fixed if zeta_lower == zeta_upper.}
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
  data_columns    = c("subjID", "trialNum", "u", "y"),
  parameters      = list(
    "kappa" = c(0, 0, Inf),
    "omega" = c(-Inf, 0, Inf),
    "zeta" = c(0, 1, Inf)
  ),
  additional_args = list(
    'L' = 3,
    'input_first' = FALSE,
    'mu0' = c(0.5, 1.0),
    'sigma0' = c(0.1, 1.0),
    'kappa_lower' = c(0),
    'kappa_upper' = c(2),
    'omega_lower' = c(-10, -15),
    'omega_upper' = c(0, 0),
    'zeta_lower' = 0,
    'zeta_upper' = 2
  ),
  regressors      = NULL,
  postpreds       = NULL,
  preprocess_func = hgf_ibrb_preprocess_func)
