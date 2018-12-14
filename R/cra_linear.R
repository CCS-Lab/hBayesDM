#' @templateVar MODEL_FUNCTION cra_linear
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang}
#' @templateVar TASK_NAME Choice Under Risk and Ambiguity Task
#' @templateVar MODEL_NAME Linear Subjective Value Model
#' @templateVar MODEL_CITE (Levy et al., 2010, J Neurophysiol)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "prob", "ambig", "reward_var", "reward_fix", "choice"
#' @templateVar PARAMETERS "alpha" (risk attitude), "beta" (ambiguity attitude), "gamma" (inverse temperature)
#' @templateVar REGRESSORS "sv", "sv_fix", "sv_var", "p_var"
#' @templateVar LENGTH_DATA_COLUMNS 6
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"prob"}{Objective probability of the variable lottery.}
#' @templateVar DETAILS_DATA_3 \item{"ambig"}{Ambiguity level of the variable lottery (0 for risky lottery; greater than 0 for ambiguous lottery).}
#' @templateVar DETAILS_DATA_4 \item{"reward_var"}{Amount of reward in variable lottery. Assumed to be greater than zero.}
#' @templateVar DETAILS_DATA_5 \item{"reward_fix"}{Amount of reward in fixed lottery. Assumed to be greater than zero.}
#' @templateVar DETAILS_DATA_6 \item{"choice"}{If the variable lottery was selected, choice == 1; otherwise choice == 0.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Levy, I., Snell, J., Nelson, A. J., Rustichini, A., & Glimcher, P. W. (2010). Neural
#'   representation of subjective value under risk and ambiguity. Journal of Neurophysiology,
#'   103(2), 1036-1047.

cra_linear <- hBayesDM_model(
  task_name       = "cra",
  model_name      = "linear",
  data_columns    = c("subjID", "prob", "ambig", "reward_var", "reward_fix", "choice"),
  parameters      = list("alpha" = c(0, 1, 2),
                         "beta"  = c(-Inf, 0, Inf),
                         "gamma" = c(0, 1, Inf)),
  regressors      = list("sv"     = 2,
                         "sv_fix" = 2,
                         "sv_var" = 2,
                         "p_var"  = 2),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    choice     <- array(0, c(n_subj, t_max))
    prob       <- array(0, c(n_subj, t_max))
    ambig      <- array(0, c(n_subj, t_max))
    reward_var <- array(0, c(n_subj, t_max))
    reward_fix <- array(0, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      choice[i, 1:t]     <- DT_subj$choice
      prob[i, 1:t]       <- DT_subj$prob
      ambig[i, 1:t]      <- DT_subj$ambig
      reward_var[i, 1:t] <- DT_subj$rewardvar
      reward_fix[i, 1:t] <- DT_subj$rewardfix
    }

    # Wrap into a list for Stan
    data_list <- list(
      N          = n_subj,
      T          = t_max,
      Tsubj      = t_subjs,
      choice     = choice,
      prob       = prob,
      ambig      = ambig,
      reward_var = reward_var,
      reward_fix = reward_fix
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

