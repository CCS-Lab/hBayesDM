#' @templateVar MODEL_FUNCTION gng_m4
#' @templateVar TASK_NAME Orthogonalized Go/Nogo Task
#' @templateVar MODEL_NAME RW (rew/pun) + noise + bias + pi
#' @templateVar MODEL_CITE (Cavanagh et al., 2013, J Neuro)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "cue", "keyPressed", "outcome"
#' @templateVar PARAMETERS "xi" (noise), "ep" (learning rate), "b" (action bias), "pi" (Pavlovian bias), "rhoRew" (reward sensitivity), "rhoPun" (punishment sensitivity)
#' @templateVar REGRESSORS "Qgo", "Qnogo", "Wgo", "Wnogo", "SV"
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"cue"}{Nominal integer representing the cue shown for that trial: 1, 2, 3, or 4.}
#' @templateVar DETAILS_DATA_3 \item{"keyPressed"}{Binary value representing the subject's response for that trial (where Press == 1; No press == 0).}
#' @templateVar DETAILS_DATA_4 \item{"outcome"}{Ternary value representing the outcome of that trial (where Positive feedback == 1; Neutral feedback == 0; Negative feedback == -1).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Cavanagh, J. F., Eisenberg, I., Guitart-Masip, M., Huys, Q., & Frank, M. J. (2013). Frontal Theta
#'   Overrides Pavlovian Learning Biases. Journal of Neuroscience, 33(19), 8541-8548.
#'   http://doi.org/10.1523/JNEUROSCI.5754-12.2013

gng_m4 <- hBayesDM_model(
  task_name       = "gng",
  model_name      = "m4",
  data_columns    = c("subjID", "cue", "keyPressed", "outcome"),
  parameters      = list("xi"     = c(0, 0.1, 1),
                         "ep"     = c(0, 0.2, 1),
                         "b"      = c(-Inf, 0, Inf),
                         "pi"     = c(-Inf, 0, Inf),
                         "rhoRew" = c(0, exp(2), Inf),
                         "rhoPun" = c(0, exp(2), Inf)),
  regressors      = list("Qgo"   = 2,
                         "Qnogo" = 2,
                         "Wgo"   = 2,
                         "Wnogo" = 2,
                         "SV"    = 2),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    cue     <- array( 1, c(n_subj, t_max))
    pressed <- array(-1, c(n_subj, t_max))
    outcome <- array( 0, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      cue[i, 1:t]     <- DT_subj$cue
      pressed[i, 1:t] <- DT_subj$keypressed
      outcome[i, 1:t] <- DT_subj$outcome
    }

    # Wrap into a list for Stan
    data_list <- list(
      N       = n_subj,
      T       = t_max,
      Tsubj   = t_subjs,
      cue     = cue,
      pressed = pressed,
      outcome = outcome
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

