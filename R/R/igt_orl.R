#' @templateVar MODEL_FUNCTION igt_orl
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/nate-haines/}{Nate Haines} <\email{haines.175@@osu.edu}>
#' @templateVar TASK_NAME Iowa Gambling Task
#' @templateVar TASK_CODE igt
#' @templateVar TASK_CITE (Ahn et al., 2008)
#' @templateVar MODEL_NAME Outcome-Representation Learning Model
#' @templateVar MODEL_CODE orl
#' @templateVar MODEL_CITE (Haines et al., 2018)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "gain", "loss"
#' @templateVar PARAMETERS \code{Arew} (reward learning rate), \code{Apun} (punishment learning rate), \code{K} (perseverance decay), \code{betaF} (outcome frequency weight), \code{betaP} (perseverance weight)
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
#' 
#' @references
#' Ahn, W. Y., Busemeyer, J. R., & Wagenmakers, E. J. (2008). Comparison of decision learning models using the generalization criterion method. Cognitive Science, 32(8), 1376-1402. http://doi.org/10.1080/03640210802352992
#'
#' Haines, N., Vassileva, J., & Ahn, W.-Y. (2018). The Outcome-Representation Learning Model: A Novel Reinforcement Learning Model of the Iowa Gambling Task. Cognitive Science. https://doi.org/10.1111/cogs.12688
#'

igt_orl <- hBayesDM_model(
  task_name       = "igt",
  model_name      = "orl",
  model_type      = "",
  data_columns    = c("subjID", "choice", "gain", "loss"),
  parameters      = list(
    "Arew" = c(0, 0.1, 1),
    "Apun" = c(0, 0.1, 1),
    "K" = c(0, 0.1, 5),
    "betaF" = c(-Inf, 0.1, Inf),
    "betaP" = c(-Inf, 1, Inf)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = igt_preprocess_func)
