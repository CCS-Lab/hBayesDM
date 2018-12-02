#' @templateVar MODEL_FUNCTION prl_fictitious_multipleB
#' @templateVar CONTRIBUTOR (for model-based regressors) \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang} and \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park}
#' @templateVar TASK_NAME Probabilistic Reversal Learning Task
#' @templateVar MODEL_NAME Fictitious Update Model
#' @templateVar MODEL_CITE (Glascher et al., 2009, Cerebral Cortex)
#' @templateVar MODEL_TYPE Multiple-Block Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "block", "choice", "outcome"
#' @templateVar PARAMETERS "eta" (learning rate), "alpha" (indecision point), "beta" (inverse temperature)
#' @templateVar REGRESSORS "ev_c", "ev_nc", "pe_c", "pe_nc", "dv"
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"block"}{A unique identifier for each of the multiple blocks within each subject.}
#' @templateVar DETAILS_DATA_3 \item{"choice"}{Integer value representing the option chosen on that trial: 1 or 2.}
#' @templateVar DETAILS_DATA_4 \item{"outcome"}{Integer value representing the outcome of that trial (where reward == 1, and loss == -1).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Glascher, J., Hampton, A. N., & O'Doherty, J. P. (2009). Determining a Role for Ventromedial
#'   Prefrontal Cortex in Encoding Action-Based Value Signals During Reward-Related Decision Making.
#'   Cerebral Cortex, 19(2), 483-495. http://doi.org/10.1093/cercor/bhn098

prl_fictitious_multipleB <- hBayesDM_model(
  task_name       = "prl",
  model_name      = "fictitious",
  model_type      = "multipleB",
  data_columns    = c("subjID", "block", "choice", "outcome"),
  parameters      = list("eta"   = c(0, 0.5, 1),
                         "alpha" = c(-Inf, 0, Inf),
                         "beta"  = c(0, 1, 10)),
  regressors      = list("ev_c"  = 3,
                         "ev_nc" = 3,
                         "pe_c"  = 3,
                         "pe_nc" = 3,
                         "dv"    = 3),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    b_subjs <- general_info$b_subjs
    b_max   <- general_info$b_max
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    choice  <- array(-1, c(n_subj, b_max, t_max))
    outcome <- array( 0, c(n_subj, b_max, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      DT_subj <- raw_data[subjid == subj]
      blocks_of_subj <- unique(DT_subj$block)

      for (b in 1:b_subjs[i]) {
        curr_block <- blocks_of_subj[b]
        DT_curr_block <- DT_subj[block == curr_block]
        t <- t_subjs[i, b]

        choice[i, b, 1:t]  <- DT_curr_block$choice
        outcome[i, b, 1:t] <- sign(DT_curr_block$outcome)  # use sign
      }
    }

    # Wrap into a list for Stan
    data_list <- list(
      N       = n_subj,
      B       = b_max,
      Bsubj   = b_subjs,
      T       = t_max,
      Tsubj   = t_subjs,
      choice  = choice,
      outcome = outcome
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

