#' @templateVar MODEL_FUNCTION gng_m1
#' @templateVar CONTRIBUTOR 
#' @templateVar TASK_NAME Orthogonalized Go/Nogo Task
#' @templateVar TASK_CODE gng
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME RW + noise
#' @templateVar MODEL_CODE m1
#' @templateVar MODEL_CITE (Guitart-Masip et al., 2012)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "cue", "keyPressed", "outcome"
#' @templateVar PARAMETERS \code{xi} (noise), \code{ep} (learning rate), \code{rho} (effective size)
#' @templateVar REGRESSORS "Qgo", "Qnogo", "Wgo", "Wnogo"
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{cue}{Nominal integer representing the cue shown for that trial: 1, 2, 3, or 4.}
#' @templateVar DETAILS_DATA_3 \item{keyPressed}{Binary value representing the subject's response for that trial (where Press == 1; No press == 0).}
#' @templateVar DETAILS_DATA_4 \item{outcome}{Ternary value representing the outcome of that trial (where Positive feedback == 1; Neutral feedback == 0; Negative feedback == -1).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Guitart-Masip, M., Huys, Q. J. M., Fuentemilla, L., Dayan, P., Duzel, E., & Dolan, R. J. (2012). Go and no-go learning in reward and punishment: Interactions between affect and effect. Neuroimage, 62(1), 154-166. https://doi.org/10.1016/j.neuroimage.2012.04.024
#'


gng_m1 <- hBayesDM_model(
  task_name       = "gng",
  model_name      = "m1",
  model_type      = "",
  data_columns    = c("subjID", "cue", "keyPressed", "outcome"),
  parameters      = list(
    "xi" = c(0, 0.1, 1),
    "ep" = c(0, 0.2, 1),
    "rho" = c(0, exp(2), Inf)
  ),
  regressors      = list(
    "Qgo" = 2,
    "Qnogo" = 2,
    "Wgo" = 2,
    "Wnogo" = 2
  ),
  postpreds       = c("y_pred"),
  preprocess_func = gng_preprocess_func)
