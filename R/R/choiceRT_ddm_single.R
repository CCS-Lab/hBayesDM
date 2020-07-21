#' @templateVar MODEL_FUNCTION choiceRT_ddm_single
#' @templateVar CONTRIBUTOR 
#' @templateVar TASK_NAME Choice Reaction Time Task
#' @templateVar TASK_CODE choiceRT
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Drift Diffusion Model
#' @templateVar MODEL_CODE ddm
#' @templateVar MODEL_CITE (Ratcliff, 1978)
#' @templateVar MODEL_TYPE Individual
#' @templateVar DATA_COLUMNS "subjID", "choice", "RT"
#' @templateVar PARAMETERS \code{alpha} (boundary separation), \code{beta} (bias), \code{delta} (drift rate), \code{tau} (non-decision time)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS 
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{choice}{Choice made for the current trial, coded as 1/2 to indicate lower/upper boundary or left/right choices (e.g., 1 1 1 2 1 2).}
#' @templateVar DETAILS_DATA_3 \item{RT}{Choice reaction time for the current trial, in **seconds** (e.g., 0.435 0.383 0.314 0.309, etc.).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 1
#' @templateVar ADDITIONAL_ARGS_1 \item{RTbound}{Floating point value representing the lower bound (i.e., minimum allowed) reaction time. Defaults to 0.1 (100 milliseconds).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R
#' 
#' @note
#' \strong{Notes:}
#' Note that this implementation is NOT the full Drift Diffusion Model as described in Ratcliff (1978). This implementation estimates the drift rate, boundary separation, starting point, and non-decision time; but not the between- and within-trial variances in these parameters.
#' Code for this model is based on codes/comments by Guido Biele, Joseph Burling, Andrew Ellis, and potential others @ Stan mailing.
#'
#' @references
#' Ratcliff, R. (1978). A theory of memory retrieval. Psychological Review, 85(2), 59-108. http://doi.org/10.1037/0033-295X.85.2.59
#'

choiceRT_ddm_single <- hBayesDM_model(
  task_name       = "choiceRT",
  model_name      = "ddm",
  model_type      = "single",
  data_columns    = c("subjID", "choice", "RT"),
  parameters      = list(
    "alpha" = c(0, 0.5, Inf),
    "beta" = c(0, 0.5, 1),
    "delta" = c(-Inf, 0, Inf),
    "tau" = c(0, 0.15, 1)
  ),
  regressors      = NULL,
  postpreds       = NULL,
  preprocess_func = choiceRT_single_preprocess_func)
