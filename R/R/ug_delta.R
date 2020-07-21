#' @templateVar MODEL_FUNCTION ug_delta
#' @templateVar CONTRIBUTOR 
#' @templateVar TASK_NAME Norm-Training Ultimatum Game
#' @templateVar TASK_CODE ug
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Rescorla-Wagner (Delta) Model
#' @templateVar MODEL_CODE delta
#' @templateVar MODEL_CITE (Gu et al., 2015)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "offer", "accept"
#' @templateVar PARAMETERS \code{alpha} (envy), \code{tau} (inverse temperature), \code{ep} (norm adaptation rate)
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
#' 
#' @references
#' Gu, X., Wang, X., Hula, A., Wang, S., Xu, S., Lohrenz, T. M., et al. (2015). Necessary, Yet Dissociable Contributions of the Insular and Ventromedial Prefrontal Cortices to Norm Adaptation: Computational and Lesion Evidence in Humans. Journal of Neuroscience, 35(2), 467-473. http://doi.org/10.1523/JNEUROSCI.2906-14.2015
#'

ug_delta <- hBayesDM_model(
  task_name       = "ug",
  model_name      = "delta",
  model_type      = "",
  data_columns    = c("subjID", "offer", "accept"),
  parameters      = list(
    "alpha" = c(0, 1, 20),
    "tau" = c(0, 1, 10),
    "ep" = c(0, 0.5, 1)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = ug_preprocess_func)
