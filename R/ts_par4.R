#' @templateVar MODEL_FUNCTION ts_par4
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park}
#' @templateVar TASK_NAME Two-Step Task
#' @templateVar TASK_CITE (Daw et al., 2011, Neuron)
#' @templateVar MODEL_NAME Hybrid Model (Daw et al., 2011; Wunderlich et al., 2012), with 4 parameters
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "level1_choice", "level2_choice", "reward"
#' @templateVar PARAMETERS "a" (learning rate for both stages 1 & 2), "beta" (inverse temperature for both stages 1 & 2), "pi" (perseverance), "w" (model-based weight)
#' @templateVar ADDITIONAL_ARG \code{trans_prob}: Common state transition probability from Stage (Level) 1 to Stage (Level) 2. Defaults to 0.7.
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"level1_choice"}{Choice made for Level (Stage) 1 (1: stimulus 1, 2: stimulus 2).}
#' @templateVar DETAILS_DATA_3 \item{"level2_choice"}{Choice made for Level (Stage) 2 (1: stimulus 3, 2: stimulus 4, 3: stimulus 5, 4: stimulus 6).\cr *Note that, in our notation, choosing stimulus 1 in Level 1 leads to stimulus 3 & 4 in Level 2 with a common (0.7 by default) transition. Similarly, choosing stimulus 2 in Level 1 leads to stimulus 5 & 6 in Level 2 with a common (0.7 by default) transition. To change this default transition probability, set the function argument \code{trans_prob} to your preferred value.}
#' @templateVar DETAILS_DATA_4 \item{"reward"}{Reward after Level 2 (0 or 1).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Daw, N. D., Gershman, S. J., Seymour, B., Ben Seymour, Dayan, P., & Dolan, R. J. (2011).
#'   Model-Based Influences on Humans' Choices and Striatal Prediction Errors. Neuron, 69(6),
#'   1204-1215. http://doi.org/10.1016/j.neuron.2011.02.027
#'
#' Wunderlich, K., Smittenaar, P., & Dolan, R. J. (2012). Dopamine enhances model-based over
#'   model-free choice behavior. Neuron, 75(3), 418-424.

ts_par4 <- hBayesDM_model(
  task_name       = "ts",
  model_name      = "par4",
  data_columns    = c("subjID", "level1_choice", "level2_choice", "reward"),
  parameters      = list("a"    = c(0, 0.5, 1),
                         "beta" = c(0, 1, Inf),
                         "pi"   = c(0, 1, 5),
                         "w"    = c(0, 0.5, 1)),
  postpreds       = c("y_pred_step1", "y_pred_step2"),
  preprocess_func = function(raw_data, general_info, trans_prob = 0.7) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    level1_choice <- array(1, c(n_subj, t_max))
    level2_choice <- array(1, c(n_subj, t_max))
    reward        <- array(0, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      level1_choice[i, 1:t] <- DT_subj$level1choice
      level2_choice[i, 1:t] <- DT_subj$level2choice
      reward[i, 1:t]        <- DT_subj$reward
    }

    # Wrap into a list for Stan
    data_list <- list(
      N             = n_subj,
      T             = t_max,
      Tsubj         = t_subjs,
      level1_choice = level1_choice,
      level2_choice = level2_choice,
      reward        = reward,
      trans_prob    = trans_prob
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

