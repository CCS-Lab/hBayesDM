#' @templateVar MODEL_FUNCTION prl_ewa
#' @templateVar CONTRIBUTOR (for model-based regressors) \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang} and \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park}
#' @templateVar TASK_NAME Probabilistic Reversal Learning Task
#' @templateVar MODEL_NAME Experience-Weighted Attraction Model
#' @templateVar MODEL_CITE (Ouden et al., 2013, Neuron)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "outcome"
#' @templateVar PARAMETERS "phi" (1 - learning rate), "rho" (experience decay factor), "beta" (inverse temperature)
#' @templateVar REGRESSORS "ev_c", "ev_nc", "ew_c", "ew_nc"
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
#' Ouden, den, H. E. M., Daw, N. D., Fernandez, G., Elshout, J. A., Rijpkema, M., Hoogman, M., et al.
#'   (2013). Dissociable Effects of Dopamine and Serotonin on Reversal Learning. Neuron, 80(4),
#'   1090-1100. http://doi.org/10.1016/j.neuron.2013.08.030

prl_ewa <- hBayesDM_model(
  task_name       = "prl",
  model_name      = "ewa",
  data_columns    = c("subjID", "choice", "outcome"),
  parameters      = list("phi"  = c(0, 0.5, 1),
                         "rho"  = c(0, 0.1, 1),
                         "beta" = c(0, 1, 10)),
  regressors      = list("ev_c"  = 2,
                         "ev_nc" = 2,
                         "ew_c"  = 2,
                         "ew_nc" = 2),
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

