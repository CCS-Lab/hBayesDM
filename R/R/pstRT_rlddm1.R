#' @templateVar MODEL_FUNCTION pstRT_rlddm1
#' @templateVar CONTRIBUTOR \href{https://hydoh.github.io/}{Hoyoung Doh} <\email{hoyoung.doh@@gmail.com}>, \href{https://medicine.yale.edu/lab/goldfarb/profile/sanghoon_kang/}{Sanghoon Kang} <\email{sanghoon.kang@@yale.edu}>, \href{https://jihyuncindyhur.github.io/}{Jihyun K. Hur} <\email{jihyun.hur@@yale.edu}>
#' @templateVar TASK_NAME Probabilistic Selection Task (with RT data)
#' @templateVar TASK_CODE pstRT
#' @templateVar TASK_CITE (Frank et al., 2007; Frank et al., 2004)
#' @templateVar MODEL_NAME Reinforcement Learning Drift Diffusion Model 1
#' @templateVar MODEL_CODE rlddm1
#' @templateVar MODEL_CITE (Pedersen et al., 2017)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "cond", "prob", "choice", "RT", "feedback"
#' @templateVar PARAMETERS \code{a} (boundary separation), \code{tau} (non-decision time), \code{v} (drift rate scaling), \code{alpha} (learning rate)
#' @templateVar REGRESSORS "Q1", "Q2"
#' @templateVar POSTPREDS "choice_os", "RT_os", "choice_sm", "RT_sm", "fd_sm"
#' @templateVar LENGTH_DATA_COLUMNS 6
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{cond}{Integer value representing the task condition of the given trial (AB == 1, CD == 2, EF == 3).}
#' @templateVar DETAILS_DATA_3 \item{prob}{Float value representing the probability that a correct response (1) is rewarded in the current task condition.}
#' @templateVar DETAILS_DATA_4 \item{choice}{Integer value representing the option chosen on the given trial (1 or 2).}
#' @templateVar DETAILS_DATA_5 \item{RT}{Float value representing the time taken for the response on the given trial.}
#' @templateVar DETAILS_DATA_6 \item{feedback}{Integer value representing the outcome of the given trial (where 'correct' == 1, and 'incorrect' == 0).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 2
#' @templateVar ADDITIONAL_ARGS_1 \item{RTbound}{Floating point value representing the lower bound (i.e., minimum allowed) reaction time. Defaults to 0.1 (100 milliseconds).}
#' @templateVar ADDITIONAL_ARGS_2 \item{initQ}{Floating point value representing the model's initial value of any choice.}
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


pstRT_rlddm1 <- hBayesDM_model(
  task_name       = "pstRT",
  model_name      = "rlddm1",
  model_type      = "",
  data_columns    = c("subjID", "cond", "prob", "choice", "RT", "feedback"),
  parameters      = list(
    "a" = c(0, 1.8, Inf),
    "tau" = c(0, 0.3, Inf),
    "v" = c(-Inf, 4.5, Inf),
    "alpha" = c(0, 0.02, 1)
  ),
  regressors      = list(
    "Q1" = 2,
    "Q2" = 2
  ),
  postpreds       = c("choice_os", "RT_os", "choice_sm", "RT_sm", "fd_sm"),
  preprocess_func = pstRT_preprocess_func)
