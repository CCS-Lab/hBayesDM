#' @templateVar MODEL_FUNCTION peer_ocu
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park}
#' @templateVar TASK_NAME Peer Influence Task
#' @templateVar TASK_CITE (Chung et al., 2015)
#' @templateVar MODEL_NAME Other-Conferred Utility (OCU) Model
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "condition", "p_gamble", "safe_Hpayoff", "safe_Lpayoff", "risky_Hpayoff", "risky_Lpayoff", "choice"
#' @templateVar PARAMETERS "rho" (risk preference), "tau" (inverse temperature), "ocu" (other-conferred utility)
#' @templateVar LENGTH_DATA_COLUMNS 8
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"condition"}{0: solo, 1: info (safe/safe), 2: info (mix), 3: info (risky/risky).}
#' @templateVar DETAILS_DATA_3 \item{"p_gamble"}{Probability of receiving a high payoff (same for both options).}
#' @templateVar DETAILS_DATA_4 \item{"safe_Hpayoff"}{High payoff of the safe option.}
#' @templateVar DETAILS_DATA_5 \item{"safe_Lpayoff"}{Low payoff of the safe option.}
#' @templateVar DETAILS_DATA_6 \item{"risky_Hpayoff"}{High payoff of the risky option.}
#' @templateVar DETAILS_DATA_7 \item{"risky_Lpayoff"}{Low payoff of the risky option.}
#' @templateVar DETAILS_DATA_8 \item{"choice"}{Which option was chosen? 0: safe, 1: risky.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Chung, D., Christopoulos, G. I., King-Casas, B., Ball, S. B., & Chiu, P. H. (2015). Social
#'   signals of safety and risk confer utility and have asymmetric effects on observers' choices.
#'   Nature Neuroscience, 18(6), 912-916.

peer_ocu <- hBayesDM_model(
  task_name       = "peer",
  model_name      = "ocu",
  data_columns    = c("subjID", "condition", "p_gamble", "safe_Hpayoff", "safe_Lpayoff", "risky_Hpayoff", "risky_Lpayoff", "choice"),
  parameters      = list("rho" = c(0, 1, 2),
                         "tau" = c(0, 1, Inf),
                         "ocu" = c(-Inf, 0, Inf)),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    condition     <- array( 0, c(n_subj, t_max))
    p_gamble      <- array( 0, c(n_subj, t_max))
    safe_Hpayoff  <- array( 0, c(n_subj, t_max))
    safe_Lpayoff  <- array( 0, c(n_subj, t_max))
    risky_Hpayoff <- array( 0, c(n_subj, t_max))
    risky_Lpayoff <- array( 0, c(n_subj, t_max))
    choice        <- array(-1, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      condition[i, 1:t]     <- DT_subj$condition
      p_gamble[i, 1:t]      <- DT_subj$pgamble
      safe_Hpayoff[i, 1:t]  <- DT_subj$safehpayoff
      safe_Lpayoff[i, 1:t]  <- DT_subj$safelpayoff
      risky_Hpayoff[i, 1:t] <- DT_subj$riskyhpayoff
      risky_Lpayoff[i, 1:t] <- DT_subj$riskylpayoff
      choice[i, 1:t]        <- DT_subj$choice
    }

    # Wrap into a list for Stan
    data_list <- list(
      N             = n_subj,
      T             = t_max,
      Tsubj         = t_subjs,
      condition     = condition,
      p_gamble      = p_gamble,
      safe_Hpayoff  = safe_Hpayoff,
      safe_Lpayoff  = safe_Lpayoff,
      risky_Hpayoff = risky_Hpayoff,
      risky_Lpayoff = risky_Lpayoff,
      choice        = choice
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

