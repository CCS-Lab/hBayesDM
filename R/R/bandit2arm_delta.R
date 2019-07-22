#' @templateVar MODEL_FUNCTION bandit2arm_delta
#' @templateVar TASK_NAME 2-Armed Bandit Task
#' @templateVar TASK_CITE (Erev et al., 2010; Hertwig et al., 2004)
#' @templateVar MODEL_NAME Rescorla-Wagner (Delta) Model
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "outcome"
#' @templateVar PARAMETERS "A" (learning rate), "tau" (inverse temperature)
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"choice"}{Integer value representing the option chosen on the given trial: 1 or 2.}
#' @templateVar DETAILS_DATA_3 \item{"outcome"}{Integer value representing the outcome of the given trial (where reward == 1, and loss == -1).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Erev, I., Ert, E., Roth, A. E., Haruvy, E., Herzog, S. M., Hau, R., et al. (2010). A choice
#'   prediction competition: Choices from experience and from description. Journal of Behavioral
#'   Decision Making, 23(1), 15-47. http://doi.org/10.1002/bdm.683
#'
#' Hertwig, R., Barron, G., Weber, E. U., & Erev, I. (2004). Decisions From Experience and the
#'   Effect of Rare Events in Risky Choice. Psychological Science, 15(8), 534-539.
#'   http://doi.org/10.1111/j.0956-7976.2004.00715.x

bandit2arm_delta <- hBayesDM_model(
  task_name       = "bandit2arm",
  model_name      = "delta",
  data_columns    = c("subjID", "choice", "outcome"),
  parameters      = list("A"   = c(0, 0.5, 1),
                         "tau" = c(0, 1, 5)),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    choice  <- array(-1, c(n_subj, t_max))
    outcome <- array( 0, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      choice[i, 1:t]  <- DT_subj$choice
      outcome[i, 1:t] <- DT_subj$outcome
    }

    # Wrap into a list for Stan
    data_list <- list(
      N       = n_subj,
      T       = t_max,
      Tsubj   = t_subjs,
      choice  = choice,
      outcome = outcome
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

