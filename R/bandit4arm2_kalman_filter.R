#' @templateVar MODEL_FUNCTION bandit4arm2_kalman_filter
#' @templateVar CONTRIBUTOR \href{https://zohyos7.github.io}{Yoonseo Zoh}, \href{https://lei-zhang.net/}{Lei Zhang}
#' @templateVar TASK_NAME 4-armed bandit task(2)
#' @templateVar MODEL_NAME Kalman filter
#' @templateVar MODEL_CITE (Daw et al., 2006, Nature)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "outcome"
#' @templateVar PARAMETERS "lambda" (decay factor), "theta" (decay center), "beta" (inverse softmax temperature), "mu0" (anticipated initial mean of all 4 options), "sigma0" (anticipated initial sd (uncertainty factor) of all 4 options), and "sigmaD" (sd of diffusion noise)
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject within data-set to be analyzed.}
#' @templateVar DETAILS_DATA_2 \item{"choice"}{Should contain a integer value representing the chosen choice option within the given trial (e.g., 1, 2, 3 or 4 in 4-arm bandit task(2)).}
#' @templateVar DETAILS_DATA_3 \item{"outcome"}{Should contain outcomes within each given trial (e.g., 1 = reward, -1 = loss).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Daw, N. D., O'Doherty, J. P., Dayan, P., Seymour, B., & Dolan, R. J. (2006). Cortical substrates for exploratory decisions
#' in humans. Nature, 441(7095), 876-879.


bandit4arm2_kalman_filter <- hBayesDM_model(
  task_name             = "bandit4arm2",
  model_name            = "kalman_filter",
  model_type            = "",
  data_columns          = c("subjID", "choice", "outcome"),
  parameters            = list("lambda" = c(0, 0.9, 1),
                               "theta" = c(0, 50, 100),
                               "beta" = c(0,0.1,1),
                               "mu0" = c(0, 85, 100),
                               "sigma0" = c(0, 6, 15),
                               "sigmaD" = c(0, 3, 15)),
  regressors            = NULL,
  preprocess_func = function(raw_data, general_info) {
    DT      <- as.data.table(raw_data)
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    choice  <- array( -1, c(n_subj, t_max))
    outcome <- array(  0, c(n_subj, t_max))

    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- DT[subjid == subj]

      choice[i, 1:t] <- DT_subj$choice
      outcome[i, 1:t] <-DT_subj$outcome
    }

    data_list <- list(
      N = n_subj,
      T = t_max,
      Tsubj = t_subjs,
      choice = choice,
      outcome = outcome
    )

    return(data_list)
  }
)

