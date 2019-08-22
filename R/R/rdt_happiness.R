#' @templateVar MODEL_FUNCTION rdt_happiness
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park} <\email{hrpark12@@gmail.com}>
#' @templateVar TASK_NAME Risky Decision Task
#' @templateVar TASK_CODE rdt
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Happiness Computational Model
#' @templateVar MODEL_CODE happiness
#' @templateVar MODEL_CITE (Rutledge et al., 2014)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "gain", "loss", "cert", "type", "gamble", "outcome", "happy", "RT_happy"
#' @templateVar PARAMETERS \code{w0} (baseline), \code{w1} (weight of certain rewards), \code{w2} (weight of expected values), \code{w3} (weight of reward prediction errors), \code{gam} (forgetting factor), \code{sig} (standard deviation of error)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 9
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{gain}{Possible (50\%) gain outcome of a risky option (e.g. 9).}
#' @templateVar DETAILS_DATA_3 \item{loss}{Possible (50\%) loss outcome of a risky option (e.g. 5, or -5).}
#' @templateVar DETAILS_DATA_4 \item{cert}{Guaranteed amount of a safe option.}
#' @templateVar DETAILS_DATA_5 \item{type}{loss == -1, mixed == 0, gain == 1}
#' @templateVar DETAILS_DATA_6 \item{gamble}{If gamble was taken, gamble == 1; else gamble == 0.}
#' @templateVar DETAILS_DATA_7 \item{outcome}{Result of the trial.}
#' @templateVar DETAILS_DATA_8 \item{happy}{Happiness score.}
#' @templateVar DETAILS_DATA_9 \item{RT_happy}{Reaction time for answering the happiness score.}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R
#' 
#' @references
#' Rutledge, R. B., Skandali, N., Dayan, P., & Dolan, R. J. (2014). A computational and neural model of momentary subjective well-being. Proceedings of the National Academy of Sciences, 111(33), 12252-12257.
#'

rdt_happiness <- hBayesDM_model(
  task_name       = "rdt",
  model_name      = "happiness",
  model_type      = "",
  data_columns    = c("subjID", "gain", "loss", "cert", "type", "gamble", "outcome", "happy", "RT_happy"),
  parameters      = list(
    "w0" = c(-Inf, 1, Inf),
    "w1" = c(-Inf, 1, Inf),
    "w2" = c(-Inf, 1, Inf),
    "w3" = c(-Inf, 1, Inf),
    "gam" = c(0, 0.5, 1),
    "sig" = c(0, 1, Inf)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = rdt_preprocess_func)
