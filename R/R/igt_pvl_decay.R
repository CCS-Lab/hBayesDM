#' @templateVar MODEL_FUNCTION igt_pvl_decay
#' @templateVar CONTRIBUTOR 
#' @templateVar TASK_NAME Iowa Gambling Task
#' @templateVar TASK_CODE igt
#' @templateVar TASK_CITE (Ahn et al., 2008)
#' @templateVar MODEL_NAME Prospect Valence Learning (PVL) Decay-RI
#' @templateVar MODEL_CODE pvl_decay
#' @templateVar MODEL_CITE (Ahn et al., 2014)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "gain", "loss"
#' @templateVar PARAMETERS \code{A} (decay rate), \code{alpha} (outcome sensitivity), \code{cons} (response consistency), \code{lambda} (loss aversion)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{choice}{Integer indicating which deck was chosen on that trial (where A==1, B==2, C==3, and D==4).}
#' @templateVar DETAILS_DATA_3 \item{gain}{Floating point value representing the amount of currency won on that trial (e.g. 50, 100).}
#' @templateVar DETAILS_DATA_4 \item{loss}{Floating point value representing the amount of currency lost on that trial (e.g. 0, -50).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 1
#' @templateVar ADDITIONAL_ARGS_1 \item{payscale}{Raw payoffs within data are divided by this number. Used for scaling data. Defaults to 100.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Ahn, W. Y., Busemeyer, J. R., & Wagenmakers, E. J. (2008). Comparison of decision learning models using the generalization criterion method. Cognitive Science, 32(8), 1376-1402. https://doi.org/10.1080/03640210802352992
#'
#' Ahn, W.-Y., Vasilev, G., Lee, S.-H., Busemeyer, J. R., Kruschke, J. K., Bechara, A., & Vassileva, J. (2014). Decision-making in stimulant and opiate addicts in protracted abstinence: evidence from computational modeling with pure users. Frontiers in Psychology, 5, 1376. https://doi.org/10.3389/fpsyg.2014.00849
#'


igt_pvl_decay <- hBayesDM_model(
  task_name       = "igt",
  model_name      = "pvl_decay",
  model_type      = "",
  data_columns    = c("subjID", "choice", "gain", "loss"),
  parameters      = list(
    "A" = c(0, 0.5, 1),
    "alpha" = c(0, 0.5, 2),
    "cons" = c(0, 1, 5),
    "lambda" = c(0, 1, 10)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = igt_preprocess_func)
