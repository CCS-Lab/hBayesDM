#' @templateVar MODEL_FUNCTION banditNarm_delta
#' @templateVar CONTRIBUTOR \href{https://github.com/cheoljun95}{Cheol Jun Cho} <\email{cjfwndnsl@@gmail.com}>
#' @templateVar TASK_NAME N-Armed Bandit Task
#' @templateVar TASK_CODE banditNarm
#' @templateVar TASK_CITE (Erev et al., 2010; Hertwig et al., 2004)
#' @templateVar MODEL_NAME Rescorla-Wagner (Delta) Model
#' @templateVar MODEL_CODE delta
#' @templateVar MODEL_CITE 
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "gain", "loss"
#' @templateVar PARAMETERS \code{A} (learning rate), \code{tau} (inverse temperature)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{choice}{Integer value representing the option chosen on the given trial: 1, 2, 3, ... N.}
#' @templateVar DETAILS_DATA_3 \item{gain}{Floating point value representing the amount of currency won on the given trial (e.g. 50, 100).}
#' @templateVar DETAILS_DATA_4 \item{loss}{Floating point value representing the amount of currency lost on the given trial (e.g. 0, -50).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 1
#' @templateVar ADDITIONAL_ARGS_1 \item{Narm}{Number of arms used in Multi-armed Bandit Task If not given, the number of unique choice will be used.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Erev, I., Ert, E., Roth, A. E., Haruvy, E., Herzog, S. M., Hau, R., et al. (2010). A choice prediction competition: Choices from experience and from description. Journal of Behavioral Decision Making, 23(1), 15-47. https://doi.org/10.1002/bdm.683
#'
#' Hertwig, R., Barron, G., Weber, E. U., & Erev, I. (2004). Decisions From Experience and the Effect of Rare Events in Risky Choice. Psychological Science, 15(8), 534-539. https://doi.org/10.1111/j.0956-7976.2004.00715.x
#'


banditNarm_delta <- hBayesDM_model(
  task_name       = "banditNarm",
  model_name      = "delta",
  model_type      = "",
  data_columns    = c("subjID", "choice", "gain", "loss"),
  parameters      = list(
    "A" = c(0, 0.5, 1),
    "tau" = c(0, 1, 5)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = banditNarm_preprocess_func)
