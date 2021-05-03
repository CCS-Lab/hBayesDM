#' @templateVar MODEL_FUNCTION prl_fictitious_woa
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang (for model-based regressors)} <\email{jaeyeong.yang1125@@gmail.com}>, \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park (for model-based regressors)} <\email{hrpark12@@gmail.com}>
#' @templateVar TASK_NAME Probabilistic Reversal Learning Task
#' @templateVar TASK_CODE prl
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Fictitious Update Model, without alpha (indecision point)
#' @templateVar MODEL_CODE fictitious_woa
#' @templateVar MODEL_CITE (Glascher et al., 2009)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "outcome"
#' @templateVar PARAMETERS \code{eta} (learning rate), \code{beta} (inverse temperature)
#' @templateVar REGRESSORS "ev_c", "ev_nc", "pe_c", "pe_nc", "dv"
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{choice}{Integer value representing the option chosen on that trial: 1 or 2.}
#' @templateVar DETAILS_DATA_3 \item{outcome}{Integer value representing the outcome of that trial (where reward == 1, and loss == -1).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Glascher, J., Hampton, A. N., & O'Doherty, J. P. (2009). Determining a Role for Ventromedial Prefrontal Cortex in Encoding Action-Based Value Signals During Reward-Related Decision Making. Cerebral Cortex, 19(2), 483-495. https://doi.org/10.1093/cercor/bhn098
#'


prl_fictitious_woa <- hBayesDM_model(
  task_name       = "prl",
  model_name      = "fictitious_woa",
  model_type      = "",
  data_columns    = c("subjID", "choice", "outcome"),
  parameters      = list(
    "eta" = c(0, 0.5, 1),
    "beta" = c(0, 1, 10)
  ),
  regressors      = list(
    "ev_c" = 2,
    "ev_nc" = 2,
    "pe_c" = 2,
    "pe_nc" = 2,
    "dv" = 2
  ),
  postpreds       = c("y_pred"),
  preprocess_func = prl_preprocess_func)
