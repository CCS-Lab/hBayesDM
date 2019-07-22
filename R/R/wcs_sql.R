#' @templateVar MODEL_FUNCTION wcs_sql
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/dayeong-min/}{Dayeong Min}
#' @templateVar TASK_NAME Wisconsin Card Sorting Task
#' @templateVar MODEL_NAME Sequential Learning Model
#' @templateVar MODEL_CITE (Bishara et al., 2010, Journal of Mathematical Psychology)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "outcome"
#' @templateVar PARAMETERS "r" (reward sensitivity), "p" (punishment sensitivity), "d" (decision consistency or inverse temperature)
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"choice"}{Integer value indicating which deck was chosen on that trial: 1, 2, 3, or 4.}
#' @templateVar DETAILS_DATA_3 \item{"outcome"}{1 or 0, indicating the outcome of that trial: correct == 1, wrong == 0.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @importFrom utils read.table
#'
#' @references
#' Bishara, A. J., Kruschke, J. K., Stout, J. C., Bechara, A., McCabe, D. P., & Busemeyer, J. R.
#'   (2010). Sequential learning models for the Wisconsin card sort task: Assessing processes in
#'   substance dependent individuals. Journal of Mathematical Psychology, 54(1), 5-13.

wcs_sql <- hBayesDM_model(
  task_name       = "wcs",
  model_name      = "sql",
  data_columns    = c("subjID", "choice", "outcome"),
  parameters      = list("r" = c(0, 0.1, 1),
                         "p" = c(0, 0.1, 1),
                         "d" = c(0, 1, 5)),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
#   t_max   <- general_info$t_max
    t_max   <- 128

    # Read predefined answer sheet
    answersheet <- system.file("extdata", "wcs_answersheet.txt", package = "hBayesDM")
    answer <- read.table(answersheet, header = TRUE)

    # Initialize data arrays
    choice           <- array( 0, c(n_subj, 4, t_max))
    outcome          <- array(-1, c(n_subj, t_max))
    choice_match_att <- array( 0, c(n_subj, t_max, 1, 3))  # Info about chosen deck (per each trial)
    deck_match_rule  <- array( 0, c(t_max, 3, 4))          # Info about all 4 decks (per each trial)

    # Write: choice, outcome, choice_match_att
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]
      DT_subj_choice  <- DT_subj$choice
      DT_subj_outcome <- DT_subj$outcome

      for (tr in 1:t) {
        ch <- DT_subj_choice[tr]
        ou <- DT_subj_outcome[tr]
        choice[i, ch, tr]            <- 1
        outcome[i, tr]               <- ou
        choice_match_att[i, tr, 1, ] <- answer[, tr] == ch
      }
    }

    # Write: deck_match_rule
    for (tr in 1:t_max) {
      for (ru in 1:3) {
        deck_match_rule[tr, ru, answer[ru, tr]] <- 1
      }
    }

    # Wrap into a list for Stan
    data_list <- list(
      N                = n_subj,
      T                = t_max,
      Tsubj            = t_subjs,
      choice           = choice,
      outcome          = outcome,
      choice_match_att = choice_match_att,
      deck_match_rule  = deck_match_rule
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

