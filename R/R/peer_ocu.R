#' @templateVar MODEL_FUNCTION peer_ocu
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park} <\email{hrpark12@@gmail.com}>
#' @templateVar TASK_NAME Peer Influence Task
#' @templateVar TASK_CODE peer
#' @templateVar TASK_CITE (Chung et al., 2015)
#' @templateVar MODEL_NAME Other-Conferred Utility (OCU) Model
#' @templateVar MODEL_CODE ocu
#' @templateVar MODEL_CITE 
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "condition", "p_gamble", "safe_Hpayoff", "safe_Lpayoff", "risky_Hpayoff", "risky_Lpayoff", "choice"
#' @templateVar PARAMETERS \code{rho} (risk preference), \code{tau} (inverse temperature), \code{ocu} (other-conferred utility)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 8
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{condition}{0: solo, 1: info (safe/safe), 2: info (mix), 3: info (risky/risky).}
#' @templateVar DETAILS_DATA_3 \item{p_gamble}{Probability of receiving a high payoff (same for both options).}
#' @templateVar DETAILS_DATA_4 \item{safe_Hpayoff}{High payoff of the safe option.}
#' @templateVar DETAILS_DATA_5 \item{safe_Lpayoff}{Low payoff of the safe option.}
#' @templateVar DETAILS_DATA_6 \item{risky_Hpayoff}{High payoff of the risky option.}
#' @templateVar DETAILS_DATA_7 \item{risky_Lpayoff}{Low payoff of the risky option.}
#' @templateVar DETAILS_DATA_8 \item{choice}{Which option was chosen? 0: safe, 1: risky.}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R
#' 
#' @references
#' Chung, D., Christopoulos, G. I., King-Casas, B., Ball, S. B., & Chiu, P. H. (2015). Social signals of safety and risk confer utility and have asymmetric effects on observers' choices. Nature Neuroscience, 18(6), 912-916.
#'

peer_ocu <- hBayesDM_model(
  task_name       = "peer",
  model_name      = "ocu",
  model_type      = "",
  data_columns    = c("subjID", "condition", "p_gamble", "safe_Hpayoff", "safe_Lpayoff", "risky_Hpayoff", "risky_Lpayoff", "choice"),
  parameters      = list(
    "rho" = c(0, 1, 2),
    "tau" = c(0, 1, Inf),
    "ocu" = c(-Inf, 0, Inf)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = peer_preprocess_func)
