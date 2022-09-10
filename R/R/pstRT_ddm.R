#' @templateVar MODEL_FUNCTION pstRT_ddm
#' @templateVar CONTRIBUTOR \href{https://hydoh.github.io/}{Hoyoung Doh} <\email{hoyoung.doh@@gmail.com}>, \href{https://medicine.yale.edu/lab/goldfarb/profile/sanghoon_kang/}{Sanghoon Kang} <\email{sanghoon.kang@@yale.edu}>, \href{https://jihyuncindyhur.github.io/}{Jihyun K. Hur} <\email{jihyun.hur@@yale.edu}>
#' @templateVar TASK_NAME Probabilistic Selection Task (with RT data)
#' @templateVar TASK_CODE pstRT
#' @templateVar TASK_CITE (Frank et al., 2007; Frank et al., 2004)
#' @templateVar MODEL_NAME Drift Diffusion Model
#' @templateVar MODEL_CODE ddm
#' @templateVar MODEL_CITE (Pedersen et al., 2017)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "cond", "choice", "RT"
#' @templateVar PARAMETERS \code{a} (boundary separation), \code{tau} (non-decision time), \code{d1} (drift rate scaling), \code{d2} (drift rate scaling), \code{d3} (drift rate scaling)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "choice_os", "RT_os"
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{cond}{Integer value representing the task condition of the given trial (AB == 1, CD == 2, EF == 3).}
#' @templateVar DETAILS_DATA_3 \item{choice}{Integer value representing the option chosen on the given trial (1 or 2).}
#' @templateVar DETAILS_DATA_4 \item{RT}{Float value representing the time taken for the response on the given trial.}
#' @templateVar LENGTH_ADDITIONAL_ARGS 1
#' @templateVar ADDITIONAL_ARGS_1 \item{RTbound}{Floating point value representing the lower bound (i.e., minimum allowed) reaction time. Defaults to 0.1 (100 milliseconds).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Frank, M. J., Santamaria, A., O'Reilly, R. C., & Willcutt, E. (2007). Testing computational models of dopamine and noradrenaline dysfunction in attention deficit/hyperactivity disorder. Neuropsychopharmacology, 32(7), 1583-1599.
#'
#' Frank, M. J., Seeberger, L. C., & O'reilly, R. C. (2004). By carrot or by stick: cognitive reinforcement learning in parkinsonism. Science, 306(5703), 1940-1943.
#'
#' Pedersen, M. L., Frank, M. J., & Biele, G. (2017). The drift diffusion model as the choice rule in reinforcement learning. Psychonomic bulletin & review, 24(4), 1234-1251.
#'


pstRT_ddm <- hBayesDM_model(
  task_name       = "pstRT",
  model_name      = "ddm",
  model_type      = "",
  data_columns    = c("subjID", "cond", "choice", "RT"),
  parameters      = list(
    "a" = c(0, 1.8, Inf),
    "tau" = c(0, 0.3, Inf),
    "d1" = c(-Inf, 0.8, Inf),
    "d2" = c(-Inf, 0.4, Inf),
    "d3" = c(-Inf, 0.3, Inf)
  ),
  regressors      = NULL,
  postpreds       = c("choice_os", "RT_os"),
  preprocess_func = pstRT_preprocess_func)
