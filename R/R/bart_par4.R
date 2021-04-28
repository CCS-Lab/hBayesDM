#' @templateVar MODEL_FUNCTION bart_par4
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park} <\email{hrpark12@@gmail.com}>, \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang} <\email{jaeyeong.yang1125@@gmail.com}>, \href{https://ccs-lab.github.io/team/ayoung-lee/}{Ayoung Lee} <\email{aylee2008@@naver.com}>, \href{https://ccs-lab.github.io/team/jeongbin-oh/}{Jeongbin Oh} <\email{ows0104@@gmail.com}>, \href{https://ccs-lab.github.io/team/jiyoon-lee/}{Jiyoon Lee} <\email{nicole.lee2001@@gmail.com}>, \href{https://ccs-lab.github.io/team/junha-jang/}{Junha Jang} <\email{andy627robo@@naver.com}>
#' @templateVar TASK_NAME Balloon Analogue Risk Task
#' @templateVar TASK_CODE bart
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Re-parameterized version of BART model with 4 parameters
#' @templateVar MODEL_CODE par4
#' @templateVar MODEL_CITE (van Ravenzwaaij et al., 2011)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "pumps", "explosion"
#' @templateVar PARAMETERS \code{phi} (prior belief of balloon not bursting), \code{eta} (updating rate), \code{gam} (risk-taking parameter), \code{tau} (inverse temperature)
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
#' van Ravenzwaaij, D., Dutilh, G., & Wagenmakers, E. J. (2011). Cognitive model decomposition of the BART: Assessment and application. Journal of Mathematical Psychology, 55(1), 94-105.
#'


bart_par4 <- hBayesDM_model(
  task_name       = "bart",
  model_name      = "par4",
  model_type      = "",
  data_columns    = c("subjID", "pumps", "explosion"),
  parameters      = list(
    "phi" = c(0, 0.5, 1),
    "eta" = c(0, 1, Inf),
    "gam" = c(0, 1, Inf),
    "tau" = c(0, 1, Inf)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = bart_preprocess_func)
