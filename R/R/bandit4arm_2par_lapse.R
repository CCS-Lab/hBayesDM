#' @templateVar MODEL_FUNCTION bandit4arm_2par_lapse
#' @templateVar CONTRIBUTOR 
#' @templateVar TASK_NAME 4-Armed Bandit Task
#' @templateVar TASK_CODE bandit4arm
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME 3 Parameter Model, without C (choice perseveration), R (reward sensitivity), and P (punishment sensitivity). But with xi (noise)
#' @templateVar MODEL_CODE 2par_lapse
#' @templateVar MODEL_CITE (Aylward et al., 2018)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "gain", "loss"
#' @templateVar PARAMETERS \code{Arew} (reward learning rate), \code{Apun} (punishment learning rate), \code{xi} (noise)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{choice}{Integer value representing the option chosen on the given trial: 1, 2, 3, or 4.}
#' @templateVar DETAILS_DATA_3 \item{gain}{Floating point value representing the amount of currency won on the given trial (e.g. 50, 100).}
#' @templateVar DETAILS_DATA_4 \item{loss}{Floating point value representing the amount of currency lost on the given trial (e.g. 0, -50).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R
#' 
#' @references
#' Aylward, Valton, Ahn, Bond, Dayan, Roiser, & Robinson (2018) Altered decision-making under uncertainty in unmedicated mood and anxiety disorders. PsyArxiv. 10.31234/osf.io/k5b8m
#'

bandit4arm_2par_lapse <- hBayesDM_model(
  task_name       = "bandit4arm",
  model_name      = "2par_lapse",
  model_type      = "",
  data_columns    = c("subjID", "choice", "gain", "loss"),
  parameters      = list(
    "Arew" = c(0, 0.1, 1),
    "Apun" = c(0, 0.1, 1),
    "xi" = c(0, 0.1, 1)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = bandit4arm_preprocess_func)
