#' @templateVar MODEL_FUNCTION dd_cs
#' @templateVar CONTRIBUTOR 
#' @templateVar TASK_NAME Delay Discounting Task
#' @templateVar TASK_CODE dd
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Constant-Sensitivity (CS) Model
#' @templateVar MODEL_CODE cs
#' @templateVar MODEL_CITE (Ebert et al., 2007)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "delay_later", "amount_later", "delay_sooner", "amount_sooner", "choice"
#' @templateVar PARAMETERS \code{r} (exponential discounting rate), \code{s} (impatience), \code{beta} (inverse temperature)
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

#' @references
#' Ebert, J. E. J., & Prelec, D. (2007). The Fragility of Time: Time-Insensitivity and Valuation of the Near and Far Future. Management Science. https://doi.org/10.1287/mnsc.1060.0671
#'


dd_cs <- hBayesDM_model(
  task_name       = "dd",
  model_name      = "cs",
  model_type      = "",
  data_columns    = c("subjID", "delay_later", "amount_later", "delay_sooner", "amount_sooner", "choice"),
  parameters      = list(
    "r" = c(0, 0.1, 1),
    "s" = c(0, 1, 10),
    "beta" = c(0, 1, 5)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = dd_preprocess_func)
