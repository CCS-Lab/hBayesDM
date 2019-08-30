#' @templateVar MODEL_FUNCTION bandit4arm2_kalman_filter
#' @templateVar CONTRIBUTOR \href{https://zohyos7.github.io}{Yoonseo Zoh} <\email{zohyos7@@gmail.com}>
#' @templateVar TASK_NAME 4-Armed Bandit Task (modified)
#' @templateVar TASK_CODE bandit4arm2
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Kalman Filter
#' @templateVar MODEL_CODE kalman_filter
#' @templateVar MODEL_CITE (Daw et al., 2006)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "outcome"
#' @templateVar PARAMETERS \code{lambda} (decay factor), \code{theta} (decay center), \code{beta} (inverse softmax temperature), \code{mu0} (anticipated initial mean of all 4 options), \code{sigma0} (anticipated initial sd (uncertainty factor) of all 4 options), \code{sigmaD} (sd of diffusion noise)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{choice}{Integer value representing the option chosen on the given trial: 1, 2, 3, or 4.}
#' @templateVar DETAILS_DATA_3 \item{outcome}{Integer value representing the outcome of the given trial (where reward == 1, and loss == -1).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R
#' 
#' @references
#' Daw, N. D., O'Doherty, J. P., Dayan, P., Seymour, B., & Dolan, R. J. (2006). Cortical substrates for exploratory decisions in humans. Nature, 441(7095), 876-879.
#'

bandit4arm2_kalman_filter <- hBayesDM_model(
  task_name       = "bandit4arm2",
  model_name      = "kalman_filter",
  model_type      = "",
  data_columns    = c("subjID", "choice", "outcome"),
  parameters      = list(
    "lambda" = c(0, 0.9, 1),
    "theta" = c(0, 50, 100),
    "beta" = c(0, 0.1, 1),
    "mu0" = c(0, 85, 100),
    "sigma0" = c(0, 6, 15),
    "sigmaD" = c(0, 3, 15)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = bandit4arm2_preprocess_func)
