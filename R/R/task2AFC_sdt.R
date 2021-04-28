#' @templateVar MODEL_FUNCTION task2AFC_sdt
#' @templateVar CONTRIBUTOR \href{https://heesunpark26.github.io/}{Heesun Park} <\email{heesunpark26@@gmail.com}>
#' @templateVar TASK_NAME 2-alternative forced choice task
#' @templateVar TASK_CODE task2AFC
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Signal detection theory model
#' @templateVar MODEL_CODE sdt
#' @templateVar MODEL_CITE 
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "stimulus", "response"
#' @templateVar PARAMETERS \code{d} (discriminability), \code{c} (decision bias (criteria))
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{stimulus}{Types of Stimuli (Should be 1 or 0. 1 for Signal and 0 for Noise)}
#' @templateVar DETAILS_DATA_3 \item{response}{Types of Responses (It should be same format as the stimulus field. Should be 1 or 0)}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R



task2AFC_sdt <- hBayesDM_model(
  task_name       = "task2AFC",
  model_name      = "sdt",
  model_type      = "",
  data_columns    = c("subjID", "stimulus", "response"),
  parameters      = list(
    "d" = c(-Inf, 0, Inf),
    "c" = c(-Inf, 0, Inf)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = task2AFC_preprocess_func)
