#' @templateVar MODEL_FUNCTION ra_noRA
#' @templateVar TASK_NAME Risk Aversion Task
#' @templateVar MODEL_NAME Prospect Theory (Sokol-Hessner et al., 2009, PNAS), without risk aversion (RA) parameter
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "gain", "loss", "cert", "gamble"
#' @templateVar PARAMETERS "lambda" (loss aversion), "tau" (inverse temperature)
#' @templateVar LENGTH_DATA_COLUMNS 5
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"gain"}{Possible (50\%) gain outcome of a risky option (e.g. 9).}
#' @templateVar DETAILS_DATA_3 \item{"loss"}{Possible (50\%) loss outcome of a risky option (e.g. 5, or -5).}
#' @templateVar DETAILS_DATA_4 \item{"cert"}{Guaranteed amount of a safe option. "cert" is assumed to be zero or greater than zero.}
#' @templateVar DETAILS_DATA_5 \item{"gamble"}{If gamble was taken, gamble == 1; else gamble == 0.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Sokol-Hessner, P., Hsu, M., Curley, N. G., Delgado, M. R., Camerer, C. F., Phelps, E. A., &
#'   Smith, E. E. (2009). Thinking like a Trader Selectively Reduces Individuals' Loss Aversion.
#'   Proceedings of the National Academy of Sciences of the United States of America, 106(13),
#'   5035-5040. http://www.pnas.org/content/106/13/5035
#'
#' @examples
#'
#' \dontrun{
#' # Paths to data published in Sokol-Hessner et al. (2009)
#' path_to_attend_data <- system.file("extdata", "ra_data_attend.txt", package = "hBayesDM")
#' path_to_regulate_data <- system.file("extdata", "ra_data_reappraisal.txt", package = "hBayesDM")
#' }

ra_noRA <- hBayesDM_model(
  task_name       = "ra",
  model_name      = "noRA",
  data_columns    = c("subjID", "gain", "loss", "cert", "gamble"),
  parameters      = list("lambda" = c(0, 1, 5),
                         "tau"    = c(0, 1, 5)),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    gain   <- array( 0, c(n_subj, t_max))
    loss   <- array( 0, c(n_subj, t_max))
    cert   <- array( 0, c(n_subj, t_max))
    gamble <- array(-1, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      gain[i, 1:t]   <- DT_subj$gain
      loss[i, 1:t]   <- abs(DT_subj$loss)  # absolute loss amount
      cert[i, 1:t]   <- DT_subj$cert
      gamble[i, 1:t] <- DT_subj$gamble
    }

    # Wrap into a list for Stan
    data_list <- list(
      N      = n_subj,
      T      = t_max,
      Tsubj  = t_subjs,
      gain   = gain,
      loss   = loss,
      cert   = cert,
      gamble = gamble
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

