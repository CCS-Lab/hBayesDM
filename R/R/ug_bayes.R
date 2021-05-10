#' @templateVar MODEL_FUNCTION ug_bayes
#' @templateVar CONTRIBUTOR 
#' @templateVar TASK_NAME Norm-Training Ultimatum Game
#' @templateVar TASK_CODE ug
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Ideal Observer Model
#' @templateVar MODEL_CODE bayes
#' @templateVar MODEL_CITE (Xiang et al., 2013)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "offer", "accept"
#' @templateVar PARAMETERS \code{alpha} (envy), \code{beta} (guilt), \code{tau} (inverse temperature)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{offer}{Floating point value representing the offer made in that trial (e.g. 4, 10, 11).}
#' @templateVar DETAILS_DATA_3 \item{accept}{1 or 0, indicating whether the offer was accepted in that trial (where accepted == 1, rejected == 0).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Xiang, T., Lohrenz, T., & Montague, P. R. (2013). Computational Substrates of Norms and Their Violations during Social Exchange. Journal of Neuroscience, 33(3), 1099-1108. https://doi.org/10.1523/JNEUROSCI.1642-12.2013
#'


ug_bayes <- hBayesDM_model(
  task_name       = "ug",
  model_name      = "bayes",
  model_type      = "",
  data_columns    = c("subjID", "offer", "accept"),
  parameters      = list(
    "alpha" = c(0, 1, 20),
    "beta" = c(0, 0.5, 10),
    "tau" = c(0, 1, 10)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = ug_preprocess_func)
