#' @templateVar MODEL_FUNCTION rdt_happiness
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park}
#' @templateVar TASK_NAME Risky Decision Task
#' @templateVar MODEL_NAME Happiness Computational Model
#' @templateVar MODEL_CITE (Rutledge et al., 2014, PNAS)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "gain", "loss", "cert", "type", "gamble", "outcome", "happy", "RT_happy"
#' @templateVar PARAMETERS "w0" (baseline), "w1" (weight of certain rewards), "w2" (weight of expected values), "w3" (weight of reward prediction errors), "gam" (forgetting factor), "sig" (standard deviation of error)
#' @templateVar LENGTH_DATA_COLUMNS 9
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"gain"}{Possible (50\%) gain outcome of a risky option (e.g. 9).}
#' @templateVar DETAILS_DATA_3 \item{"loss"}{Possible (50\%) loss outcome of a risky option (e.g. 5, or -5).}
#' @templateVar DETAILS_DATA_4 \item{"cert"}{Guaranteed amount of a safe option.}
#' @templateVar DETAILS_DATA_5 \item{"type"}{loss == -1, mixed == 0, gain == 1}
#' @templateVar DETAILS_DATA_6 \item{"gamble"}{If gamble was taken, gamble == 1; else gamble == 0.}
#' @templateVar DETAILS_DATA_7 \item{"outcome"}{Result of the trial.}
#' @templateVar DETAILS_DATA_8 \item{"happy"}{Happiness score.}
#' @templateVar DETAILS_DATA_9 \item{"RT_happy"}{Reaction time for answering the happiness score.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Rutledge, R. B., Skandali, N., Dayan, P., & Dolan, R. J. (2014). A computational and neural model
#'   of momentary subjective well-being. Proceedings of the National Academy of Sciences, 111(33),
#'   12252-12257.

rdt_happiness <- hBayesDM_model(
  task_name       = "rdt",
  model_name      = "happiness",
  data_columns    = c("subjID", "gain", "loss", "cert", "type", "gamble", "outcome", "happy", "RT_happy"),
  parameters      = list("w0"  = c(-Inf, 1, Inf),
                         "w1"  = c(-Inf, 1, Inf),
                         "w2"  = c(-Inf, 1, Inf),
                         "w3"  = c(-Inf, 1, Inf),
                         "gam" = c(0, 0.5, 1),
                         "sig" = c(0, 1, Inf)),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    gain     <- array( 0, c(n_subj, t_max))
    loss     <- array( 0, c(n_subj, t_max))
    cert     <- array( 0, c(n_subj, t_max))
    type     <- array(-1, c(n_subj, t_max))
    gamble   <- array(-1, c(n_subj, t_max))
    outcome  <- array( 0, c(n_subj, t_max))
    happy    <- array( 0, c(n_subj, t_max))
    RT_happy <- array( 0, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      gain[i, 1:t]     <- DT_subj$gain
      loss[i, 1:t]     <- abs(DT_subj$loss)  # absolute loss amount
      cert[i, 1:t]     <- DT_subj$cert
      type[i, 1:t]     <- DT_subj$type
      gamble[i, 1:t]   <- DT_subj$gamble
      outcome[i, 1:t]  <- DT_subj$outcome
      happy[i, 1:t]    <- DT_subj$happy
      RT_happy[i, 1:t] <- DT_subj$rthappy
    }

    # Wrap into a list for Stan
    data_list <- list(
      N        = n_subj,
      T        = t_max,
      Tsubj    = t_subjs,
      gain     = gain,
      loss     = loss,
      cert     = cert,
      type     = type,
      gamble   = gamble,
      outcome  = outcome,
      happy    = happy,
      RT_happy = RT_happy
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

