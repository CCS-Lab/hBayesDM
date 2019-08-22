#' @templateVar MODEL_FUNCTION dd_exp
#' @templateVar CONTRIBUTOR 
#' @templateVar TASK_NAME Delay Discounting Task
#' @templateVar TASK_CODE dd
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Exponential Model
#' @templateVar MODEL_CODE exp
#' @templateVar MODEL_CITE (Samuelson, 1937)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "delay_later", "amount_later", "delay_sooner", "amount_sooner", "choice"
#' @templateVar PARAMETERS \code{r} (exponential discounting rate), \code{beta} (inverse temperature)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 6
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{delay_later}{An integer representing the delayed days for the later option (e.g. 1, 6, 28).}
#' @templateVar DETAILS_DATA_3 \item{amount_later}{A floating point number representing the amount for the later option (e.g. 10.5, 13.4, 30.9).}
#' @templateVar DETAILS_DATA_4 \item{delay_sooner}{An integer representing the delayed days for the sooner option (e.g. 0).}
#' @templateVar DETAILS_DATA_5 \item{amount_sooner}{A floating point number representing the amount for the sooner option (e.g. 10).}
#' @templateVar DETAILS_DATA_6 \item{choice}{If amount_later was selected, choice == 1; else if amount_sooner was selected, choice == 0.}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R
#' 
#' @references
#' Samuelson, P. A. (1937). A Note on Measurement of Utility. The Review of Economic Studies, 4(2), 155. http://doi.org/10.2307/2967612
#'

dd_exp <- hBayesDM_model(
  task_name       = "dd",
  model_name      = "exp",
  model_type      = "",
  data_columns    = c("subjID", "delay_later", "amount_later", "delay_sooner", "amount_sooner", "choice"),
  parameters      = list(
    "r" = c(0, 0.1, 1),
    "beta" = c(0, 1, 5)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = dd_preprocess_func)
