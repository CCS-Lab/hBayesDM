#' @templateVar MODEL_FUNCTION banditNarm_lapse_decay
#' @templateVar CONTRIBUTOR \href{https://github.com/cheoljun95}{Cheol Jun Cho} <\email{cjfwndnsl@@gmail.com}>
#' @templateVar TASK_NAME N-Armed Bandit Task
#' @templateVar TASK_CODE banditNarm
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME 5 Parameter Model, without C (choice perseveration) but with xi (noise). Added decay rate (Niv et al., 2015, J. Neuro).
#' @templateVar MODEL_CODE lapse_decay
#' @templateVar MODEL_CITE (Aylward et al., 2018)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "gain", "loss"
#' @templateVar PARAMETERS \code{Arew} (reward learning rate), \code{Apun} (punishment learning rate), \code{R} (reward sensitivity), \code{P} (punishment sensitivity), \code{xi} (noise), \code{d} (decay rate)
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
#' Aylward, Valton, Ahn, Bond, Dayan, Roiser, & Robinson (2018) Altered decision-making under uncertainty in unmedicated mood and anxiety disorders. PsyArxiv. 10.31234/osf.io/k5b8m
#'


banditNarm_lapse_decay <- hBayesDM_model(
  task_name       = "banditNarm",
  model_name      = "lapse_decay",
  model_type      = "",
  data_columns    = c("subjID", "choice", "gain", "loss"),
  parameters      = list(
    "Arew" = c(0, 0.1, 1),
    "Apun" = c(0, 0.1, 1),
    "R" = c(0, 1, 30),
    "P" = c(0, 1, 30),
    "xi" = c(0, 0.1, 1),
    "d" = c(0, 0.1, 1)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = banditNarm_preprocess_func)
