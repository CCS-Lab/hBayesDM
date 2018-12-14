#' @templateVar MODEL_FUNCTION pst_gainloss_Q
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang}
#' @templateVar TASK_NAME Probabilistic Selection Task
#' @templateVar MODEL_NAME Gain-Loss Q Learning Model
#' @templateVar MODEL_CITE (Frank et al., 2007, PNAS)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "type", "choice", "reward"
#' @templateVar PARAMETERS "alpha_pos" (learning rate for positive feedbacks), "alpha_neg" (learning rate for negative feedbacks), "beta" (inverse temperature)
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"type"}{Two-digit number indicating which pair of stimuli were presented for that trial, e.g. \code{12}, \code{34}, or \code{56}. The digit on the left (tens-digit) indicates the presented stimulus for option1, while the digit on the right (ones-digit) indicates that for option2.\cr Code for each stimulus type (1~6) is defined as below: \tabular{ccl}{Code \tab Stimulus \tab Probability to win \cr \code{1} \tab A \tab 80\% \cr \code{2} \tab B \tab 20\% \cr \code{3} \tab C \tab 70\% \cr \code{4} \tab D \tab 30\% \cr \code{5} \tab E \tab 60\% \cr \code{6} \tab F \tab 40\%} The modeling will still work even if different probabilities are used for the stimuli; however, the total number of stimuli should be less than or equal to 6.}
#' @templateVar DETAILS_DATA_3 \item{"choice"}{Whether the subject chose the left option (option1) out of the given two options (i.e. if option1 was chosen, 1; if option2 was chosen, 0).}
#' @templateVar DETAILS_DATA_4 \item{"reward"}{Amount of reward earned as a result of the trial.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Frank, M. J., Moustafa, A. A., Haughey, H. M., Curran, T., & Hutchison, K. E. (2007). Genetic
#'   triple dissociation reveals multiple roles for dopamine in reinforcement learning. Proceedings
#'   of the National Academy of Sciences, 104(41), 16311-16316.

pst_gainloss_Q <- hBayesDM_model(
  task_name       = "pst",
  model_name      = "gainloss_Q",
  data_columns    = c("subjID", "type", "choice", "reward"),
  parameters      = list("alpha_pos" = c(0, 0.5, 1),
                         "alpha_neg" = c(0, 0.5, 1),
                         "beta"      = c(0, 1, 10)),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    option1 <- array(-1, c(n_subj, t_max))
    option2 <- array(-1, c(n_subj, t_max))
    choice  <- array(-1, c(n_subj, t_max))
    reward  <- array(-1, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      option1[i, 1:t] <- DT_subj$type %/% 10
      option2[i, 1:t] <- DT_subj$type %% 10
      choice[i, 1:t]  <- DT_subj$choice
      reward[i, 1:t]  <- DT_subj$reward
    }

    # Wrap into a list for Stan
    data_list <- list(
      N       = n_subj,
      T       = t_max,
      Tsubj   = t_subjs,
      option1 = option1,
      option2 = option2,
      choice  = choice,
      reward  = reward
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

