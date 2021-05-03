#' @templateVar MODEL_FUNCTION gng_m4
#' @templateVar CONTRIBUTOR 
#' @templateVar TASK_NAME Orthogonalized Go/Nogo Task
#' @templateVar TASK_CODE gng
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME RW (rew/pun) + noise + bias + pi
#' @templateVar MODEL_CODE m4
#' @templateVar MODEL_CITE (Cavanagh et al., 2013)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "cue", "keyPressed", "outcome"
#' @templateVar PARAMETERS \code{xi} (noise), \code{ep} (learning rate), \code{b} (action bias), \code{pi} (Pavlovian bias), \code{rhoRew} (reward sensitivity), \code{rhoPun} (punishment sensitivity)
#' @templateVar REGRESSORS "Qgo", "Qnogo", "Wgo", "Wnogo", "SV"
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
#' Cavanagh, J. F., Eisenberg, I., Guitart-Masip, M., Huys, Q., & Frank, M. J. (2013). Frontal Theta Overrides Pavlovian Learning Biases. Journal of Neuroscience, 33(19), 8541-8548. https://doi.org/10.1523/JNEUROSCI.5754-12.2013
#'


gng_m4 <- hBayesDM_model(
  task_name       = "gng",
  model_name      = "m4",
  model_type      = "",
  data_columns    = c("subjID", "cue", "keyPressed", "outcome"),
  parameters      = list(
    "xi" = c(0, 0.1, 1),
    "ep" = c(0, 0.2, 1),
    "b" = c(-Inf, 0, Inf),
    "pi" = c(-Inf, 0, Inf),
    "rhoRew" = c(0, exp(2), Inf),
    "rhoPun" = c(0, exp(2), Inf)
  ),
  regressors      = list(
    "Qgo" = 2,
    "Qnogo" = 2,
    "Wgo" = 2,
    "Wnogo" = 2,
    "SV" = 2
  ),
  postpreds       = c("y_pred"),
  preprocess_func = gng_preprocess_func)
