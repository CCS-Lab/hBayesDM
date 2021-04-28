#' @templateVar MODEL_FUNCTION alt_gamma
#' @templateVar CONTRIBUTOR \href{https://github.com/lilihub}{Lili Zhang} <\email{lili.zhang27@@mail.dcu.ie}>
#' @templateVar TASK_NAME Aversive Learning Task
#' @templateVar TASK_CODE alt
#' @templateVar TASK_CITE (Browning et al., 2015)
#' @templateVar MODEL_NAME Rescorla-Wagner (Gamma) Model
#' @templateVar MODEL_CODE gamma
#' @templateVar MODEL_CITE 
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "outcome", "bluePunish", "orangePunish"
#' @templateVar PARAMETERS \code{A} (learning rate), \code{beta} (inverse temperature), \code{gamma} (risk preference)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 5
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{choice}{Integer value representing the option chosen on the given trial (blue == 1, orange == 2).}
#' @templateVar DETAILS_DATA_3 \item{outcome}{Integer value representing the outcome of the given trial (punishment == 1, and non-punishment == 0).}
#' @templateVar DETAILS_DATA_4 \item{bluePunish}{Floating point value representing the magnitude of punishment for blue on that trial (e.g., 10, 97)}
#' @templateVar DETAILS_DATA_5 \item{orangePunish}{Floating point value representing the magnitude of punishment for orange on that trial (e.g., 23, 45)}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Browning, M., Behrens, T. E., Jocham, G., O'reilly, J. X., & Bishop, S. J. (2015). Anxious individuals have difficulty learning the causal statistics of aversive environments. Nature neuroscience, 18(4), 590.
#'


alt_gamma <- hBayesDM_model(
  task_name       = "alt",
  model_name      = "gamma",
  model_type      = "",
  data_columns    = c("subjID", "choice", "outcome", "bluePunish", "orangePunish"),
  parameters      = list(
    "A" = c(0, 0.5, 1),
    "beta" = c(0, 1, 20),
    "gamma" = c(0, 1, 10)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = alt_preprocess_func)
