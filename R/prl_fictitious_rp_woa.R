#' @templateVar MODEL_FUNCTION prl_fictitious_rp_woa
#' @templateVar CONTRIBUTOR (for model-based regressors) \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang} and \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park}
#' @templateVar TASK_NAME Probabilistic Reversal Learning Task
#' @templateVar MODEL_NAME Fictitious Update Model (Glascher et al., 2009, Cerebral Cortex), with separate learning rates for positive and negative prediction error (PE), without alpha (indecision point)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "outcome"
#' @templateVar PARAMETERS "eta_pos" (learning rate, +PE), "eta_neg" (learning rate, -PE), "beta" (inverse temperature)
#' @templateVar REGRESSORS "ev_c", "ev_nc", "pe_c", "pe_nc", "dv"
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"choice"}{Integer value representing the option chosen on that trial: 1 or 2.}
#' @templateVar DETAILS_DATA_3 \item{"outcome"}{Integer value representing the outcome of that trial (where reward == 1, and loss == -1).}
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
#'
#' Ouden, den, H. E. M., Daw, N. D., Fernandez, G., Elshout, J. A., Rijpkema, M., Hoogman, M., et al.
#'   (2013). Dissociable Effects of Dopamine and Serotonin on Reversal Learning. Neuron, 80(4),
#'   1090-1100. http://doi.org/10.1016/j.neuron.2013.08.030

prl_fictitious_rp_woa <- hBayesDM_model(
  task_name       = "prl",
  model_name      = "fictitious_rp_woa",
  data_columns    = c("subjID", "choice", "outcome"),
  parameters      = list("eta_pos" = c(0, 0.5, 1),
                         "eta_neg" = c(0, 0.5, 1),
                         "beta"    = c(0, 1, 10)),
  regressors      = list("ev_c"  = 2,
                         "ev_nc" = 2,
                         "pe_c"  = 2,
                         "pe_nc" = 2,
                         "dv"    = 2),
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
      outcome[i, 1:t] <- sign(DT_subj$outcome)  # use sign
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

