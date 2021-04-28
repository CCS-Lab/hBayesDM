#' @templateVar MODEL_FUNCTION bart_ewmv
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park} <\email{hrpark12@@gmail.com}>, \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang} <\email{jaeyeong.yang1125@@gmail.com}>
#' @templateVar TASK_NAME Balloon Analogue Risk Task
#' @templateVar TASK_CODE bart
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Exponential-Weight Mean-Variance Model
#' @templateVar MODEL_CODE ewmv
#' @templateVar MODEL_CITE (Park et al., 2020)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "pumps", "explosion"
#' @templateVar PARAMETERS \code{phi} (prior belief of burst), \code{eta} (updating exponent), \code{rho} (risk preference), \code{tau} (inverse temperature), \code{lambda} (loss aversion)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{pumps}{The number of pumps.}
#' @templateVar DETAILS_DATA_3 \item{explosion}{0: intact, 1: burst}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Park, H., Yang, J., Vassileva, J., & Ahn, W. (2020). The Exponential-Weight Mean-Variance Model: A novel computational model for the Balloon Analogue Risk Task. https://doi.org/10.31234/osf.io/sdzj4
#'


bart_ewmv <- hBayesDM_model(
  task_name       = "bart",
  model_name      = "ewmv",
  model_type      = "",
  data_columns    = c("subjID", "pumps", "explosion"),
  parameters      = list(
    "phi" = c(0, 0.5, 1),
    "eta" = c(0, 0.5, 1),
    "rho" = c(-0.5, 0, 0.5),
    "tau" = c(0, 1, Inf),
    "lambda" = c(0, 1, Inf)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = bart_preprocess_func)
