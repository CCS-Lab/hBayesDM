#' @templateVar MODEL_FUNCTION ra_prospect
#' @templateVar CONTRIBUTOR 
#' @templateVar TASK_NAME Risk Aversion Task
#' @templateVar TASK_CODE ra
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Prospect Theory
#' @templateVar MODEL_CODE prospect
#' @templateVar MODEL_CITE (Sokol-Hessner et al., 2009)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "gain", "loss", "cert", "gamble"
#' @templateVar PARAMETERS \code{rho} (risk aversion), \code{lambda} (loss aversion), \code{tau} (inverse temperature)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 5
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{gain}{Possible (50\%) gain outcome of a risky option (e.g. 9).}
#' @templateVar DETAILS_DATA_3 \item{loss}{Possible (50\%) loss outcome of a risky option (e.g. 5, or -5).}
#' @templateVar DETAILS_DATA_4 \item{cert}{Guaranteed amount of a safe option. "cert" is assumed to be zero or greater than zero.}
#' @templateVar DETAILS_DATA_5 \item{gamble}{If gamble was taken, gamble == 1; else gamble == 0.}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Sokol-Hessner, P., Hsu, M., Curley, N. G., Delgado, M. R., Camerer, C. F., Phelps, E. A., & Smith, E. E. (2009). Thinking like a Trader Selectively Reduces Individuals' Loss Aversion. Proceedings of the National Academy of Sciences of the United States of America, 106(13), 5035-5040. https://www.pnas.org/content/106/13/5035
#'


ra_prospect <- hBayesDM_model(
  task_name       = "ra",
  model_name      = "prospect",
  model_type      = "",
  data_columns    = c("subjID", "gain", "loss", "cert", "gamble"),
  parameters      = list(
    "rho" = c(0, 1, 2),
    "lambda" = c(0, 1, 5),
    "tau" = c(0, 1, 30)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = ra_preprocess_func)
