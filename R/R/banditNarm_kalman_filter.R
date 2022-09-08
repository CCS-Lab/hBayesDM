#' @templateVar MODEL_FUNCTION banditNarm_kalman_filter
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/yoonseo-zoh/}{Yoonseo Zoh} <\email{zohyos7@@gmail.com}>, \href{https://github.com/cheoljun95}{Cheol Jun Cho} <\email{cjfwndnsl@@gmail.com}>
#' @templateVar TASK_NAME N-Armed Bandit Task (modified)
#' @templateVar TASK_CODE banditNarm
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Kalman Filter
#' @templateVar MODEL_CODE kalman_filter
#' @templateVar MODEL_CITE (Daw et al., 2006)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "gain", "loss"
#' @templateVar PARAMETERS \code{lambda} (decay factor), \code{theta} (decay center), \code{beta} (inverse softmax temperature), \code{mu0} (anticipated initial mean of all 4 options), \code{s0} (anticipated initial sd (uncertainty factor) of all 4 options), \code{sD} (sd of diffusion noise)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{choice}{Integer value representing the option chosen on the given trial: 1, 2, 3, ... N.}
#' @templateVar DETAILS_DATA_3 \item{gain}{Floating point value representing the amount of currency won on the given trial (e.g. 50, 100).}
#' @templateVar DETAILS_DATA_4 \item{loss}{Floating point value representing the amount of currency lost on the given trial (e.g. 0, -50).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 1
#' @templateVar ADDITIONAL_ARGS_1 \item{Narm}{Number of arms used in Multi-armed Bandit Task If not given, the number of unique choice will be used.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Daw, N. D., O'Doherty, J. P., Dayan, P., Seymour, B., & Dolan, R. J. (2006). Cortical substrates for exploratory decisions in humans. Nature, 441(7095), 876-879.
#'


banditNarm_kalman_filter <- hBayesDM_model(
  task_name       = "banditNarm",
  model_name      = "kalman_filter",
  model_type      = "",
  data_columns    = c("subjID", "choice", "gain", "loss"),
  parameters      = list(
    "lambda" = c(0, 0.9, 1),
    "theta" = c(0, 50, 100),
    "beta" = c(0, 0.1, 1),
    "mu0" = c(0, 85, 100),
    "s0" = c(0, 6, 15),
    "sD" = c(0, 3, 15)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = banditNarm_preprocess_func)
