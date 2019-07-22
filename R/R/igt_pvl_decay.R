#' @templateVar MODEL_FUNCTION igt_pvl_decay
#' @templateVar TASK_NAME Iowa Gambling Task
#' @templateVar MODEL_NAME Prospect Valence Learning (PVL) Decay-RI
#' @templateVar MODEL_CITE (Ahn et al., 2014, Frontiers in Psychology)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "gain", "loss"
#' @templateVar PARAMETERS "A" (decay rate), "alpha" (outcome sensitivity), "cons" (response consistency), "lambda" (loss aversion)
#' @templateVar ADDITIONAL_ARG \code{payscale}: Raw payoffs within data are divided by this number. Used for scaling data. Defaults to 100.
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"choice"}{Integer indicating which deck was chosen on that trial (where A==1, B==2, C==3, and D==4).}
#' @templateVar DETAILS_DATA_3 \item{"gain"}{Floating point value representing the amount of currency won on that trial (e.g. 50, 100).}
#' @templateVar DETAILS_DATA_4 \item{"loss"}{Floating point value representing the amount of currency lost on that trial (e.g. 0, -50).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Ahn, W.-Y., Vasilev, G., Lee, S.-H., Busemeyer, J. R., Kruschke, J. K., Bechara, A., & Vassileva,
#'   J. (2014). Decision-making in stimulant and opiate addicts in protracted abstinence: evidence
#'   from computational modeling with pure users. Frontiers in Psychology, 5, 1376.
#'   http://doi.org/10.3389/fpsyg.2014.00849

igt_pvl_decay <- hBayesDM_model(
  task_name       = "igt",
  model_name      = "pvl_decay",
  data_columns    = c("subjID", "choice", "gain", "loss"),
  parameters      = list("A"      = c(0, 0.5, 1),
                         "alpha"  = c(0, 0.5, 2),
                         "cons"   = c(0, 1, 5),
                         "lambda" = c(0, 1, 10)),
  preprocess_func = function(raw_data, general_info, payscale = 100) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize data arrays
    Ydata    <- array(-1, c(n_subj, t_max))
    RLmatrix <- array( 0, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      Ydata[i, 1:t]    <- DT_subj$choice
      RLmatrix[i, 1:t] <- DT_subj$gain - abs(DT_subj$loss)
    }

    # Wrap into a list for Stan
    data_list <- list(
      N       = n_subj,
      T       = t_max,
      Tsubj   = t_subjs,
      choice  = Ydata,
      outcome = RLmatrix / payscale
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

