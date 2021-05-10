#' @templateVar MODEL_FUNCTION wcs_sql
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/dayeong-min/}{Dayeong Min} <\email{mindy2801@@snu.ac.kr}>
#' @templateVar TASK_NAME Wisconsin Card Sorting Task
#' @templateVar TASK_CODE wcs
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Sequential Learning Model
#' @templateVar MODEL_CODE sql
#' @templateVar MODEL_CITE (Bishara et al., 2010)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "outcome"
#' @templateVar PARAMETERS \code{r} (reward sensitivity), \code{p} (punishment sensitivity), \code{d} (decision consistency or inverse temperature)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{choice}{Integer value indicating which deck was chosen on that trial: 1, 2, 3, or 4.}
#' @templateVar DETAILS_DATA_3 \item{outcome}{1 or 0, indicating the outcome of that trial: correct == 1, wrong == 0.}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Bishara, A. J., Kruschke, J. K., Stout, J. C., Bechara, A., McCabe, D. P., & Busemeyer, J. R. (2010). Sequential learning models for the Wisconsin card sort task: Assessing processes in substance dependent individuals. Journal of Mathematical Psychology, 54(1), 5-13.
#'


wcs_sql <- hBayesDM_model(
  task_name       = "wcs",
  model_name      = "sql",
  model_type      = "",
  data_columns    = c("subjID", "choice", "outcome"),
  parameters      = list(
    "r" = c(0, 0.1, 1),
    "p" = c(0, 0.1, 1),
    "d" = c(0, 1, 5)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = wcs_preprocess_func)
