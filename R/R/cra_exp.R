#' @templateVar MODEL_FUNCTION cra_exp
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang} <\email{jaeyeong.yang1125@@gmail.com}>
#' @templateVar TASK_NAME Choice Under Risk and Ambiguity Task
#' @templateVar TASK_CODE cra
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Exponential Subjective Value Model
#' @templateVar MODEL_CODE exp
#' @templateVar MODEL_CITE (Hsu et al., 2005)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "prob", "ambig", "reward_var", "reward_fix", "choice"
#' @templateVar PARAMETERS \code{alpha} (risk attitude), \code{beta} (ambiguity attitude), \code{gamma} (inverse temperature)
#' @templateVar REGRESSORS "sv", "sv_fix", "sv_var", "p_var"
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 6
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{prob}{Objective probability of the variable lottery.}
#' @templateVar DETAILS_DATA_3 \item{ambig}{Ambiguity level of the variable lottery (0 for risky lottery; greater than 0 for ambiguous lottery).}
#' @templateVar DETAILS_DATA_4 \item{reward_var}{Amount of reward in variable lottery. Assumed to be greater than zero.}
#' @templateVar DETAILS_DATA_5 \item{reward_fix}{Amount of reward in fixed lottery. Assumed to be greater than zero.}
#' @templateVar DETAILS_DATA_6 \item{choice}{If the variable lottery was selected, choice == 1; otherwise choice == 0.}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R
#' 
#' @references
#' Hsu, M., Bhatt, M., Adolphs, R., Tranel, D., & Camerer, C. F. (2005). Neural systems responding to degrees of uncertainty in human decision-making. Science, 310(5754), 1680-1683. https://doi.org/10.1126/science.1115327
#'

cra_exp <- hBayesDM_model(
  task_name       = "cra",
  model_name      = "exp",
  model_type      = "",
  data_columns    = c("subjID", "prob", "ambig", "reward_var", "reward_fix", "choice"),
  parameters      = list(
    "alpha" = c(0, 1, 2),
    "beta" = c(-Inf, 0, Inf),
    "gamma" = c(0, 1, Inf)
  ),
  regressors      = list(
    "sv" = 2,
    "sv_fix" = 2,
    "sv_var" = 2,
    "p_var" = 2
  ),
  postpreds       = c("y_pred"),
  preprocess_func = cra_preprocess_func)
