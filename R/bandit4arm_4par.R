#' @templateVar MODEL_FUNCTION bandit4arm_4par
#' @templateVar TASK_NAME 4-Armed Bandit Task
#' @templateVar MODEL_NAME 4 Parameter Model, without C (choice perseveration)
#' @templateVar MODEL_CITE (Seymour et al., 2012, J Neuro)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "gain", "loss"
#' @templateVar PARAMETERS "Arew" (reward learning rate), "Apun" (punishment learning rate), "R" (reward sensitivity), "P" (punishment sensitivity)
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"choice"}{Integer value representing the option chosen on the given trial: 1, 2, 3, or 4.}
#' @templateVar DETAILS_DATA_3 \item{"gain"}{Floating point value representing the amount of currency won on the given trial (e.g. 50, 100).}
#' @templateVar DETAILS_DATA_4 \item{"loss"}{Floating point value representing the amount of currency lost on the given trial (e.g. 0, -50).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Seymour, Daw, Roiser, Dayan, & Dolan (2012). Serotonin Selectively Modulates Reward Value in
#'   Human Decision-Making. J Neuro, 32(17), 5833-5842.

bandit4arm_4par <- hBayesDM_model(
  task_name       = "bandit4arm",
  model_name      = "4par",
  data_columns    = c("subjID", "choice", "gain", "choice"),
  parameters      = list("Arew" = c(0, 0.1, 1),
                         "Apun" = c(0, 0.1, 1),
                         "R"    = c(0, 1, 30),
                         "P"    = c(0, 1, 30)),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    rew    <- array( 0, c(n_subj, t_max))
    los    <- array( 0, c(n_subj, t_max))
    choice <- array(-1, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      rew[i, 1:t]    <- DT_subj$gain
      los[i, 1:t]    <- -1 * abs(DT_subj$loss)
      choice[i, 1:t] <- DT_subj$choice
    }

    # Wrap into a list for Stan
    data_list <- list(
      N      = n_subj,
      T      = t_max,
      Tsubj  = t_subjs,
      rew    = rew,
      los    = los,
      choice = choice
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

