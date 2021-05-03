#' @templateVar MODEL_FUNCTION prl_rp
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang (for model-based regressors)} <\email{jaeyeong.yang1125@@gmail.com}>, \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park (for model-based regressors)} <\email{hrpark12@@gmail.com}>
#' @templateVar TASK_NAME Probabilistic Reversal Learning Task
#' @templateVar TASK_CODE prl
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Reward-Punishment Model
#' @templateVar MODEL_CODE rp
#' @templateVar MODEL_CITE (Ouden et al., 2013)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "outcome"
#' @templateVar PARAMETERS \code{Apun} (punishment learning rate), \code{Arew} (reward learning rate), \code{beta} (inverse temperature)
#' @templateVar REGRESSORS "ev_c", "ev_nc", "pe"
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
#' Ouden, den, H. E. M., Daw, N. D., Fernandez, G., Elshout, J. A., Rijpkema, M., Hoogman, M., et al. (2013). Dissociable Effects of Dopamine and Serotonin on Reversal Learning. Neuron, 80(4), 1090-1100. https://doi.org/10.1016/j.neuron.2013.08.030
#'


prl_rp <- hBayesDM_model(
  task_name       = "prl",
  model_name      = "rp",
  model_type      = "",
  data_columns    = c("subjID", "choice", "outcome"),
  parameters      = list(
    "Apun" = c(0, 0.1, 1),
    "Arew" = c(0, 0.1, 1),
    "beta" = c(0, 1, 10)
  ),
  regressors      = list(
    "ev_c" = 2,
    "ev_nc" = 2,
    "pe" = 2
  ),
  postpreds       = c("y_pred"),
  preprocess_func = prl_preprocess_func)
