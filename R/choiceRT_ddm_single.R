#' @templateVar MODEL_FUNCTION choiceRT_ddm_single
#' @templateVar TASK_NAME Choice Reaction Time Task
#' @templateVar MODEL_NAME Drift Diffusion Model
#' @templateVar MODEL_CITE (Ratcliff, 1978, Psychological Review)\cr *Note that this implementation is \strong{not} the full Drift Diffusion Model as described in Ratcliff (1978). This implementation estimates the drift rate, boundary separation, starting point, and non-decision time; but not the between- and within-trial variances in these parameters.
#' @templateVar MODEL_TYPE Individual
#' @templateVar DATA_COLUMNS "subjID", "choice", "RT"
#' @templateVar PARAMETERS "alpha" (boundary separation), "beta" (bias), "delta" (drift rate), "tau" (non-decision time)
#' @templateVar IS_NULL_POSTPREDS TRUE
#' @templateVar ADDITIONAL_ARG \code{RTbound}: Floating point value representing the lower bound (i.e., minimum allowed) reaction time. Defaults to 0.1 (100 milliseconds).
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"choice"}{Choice made for the current trial, coded as \code{1}/\code{2} to indicate lower/upper boundary or left/right choices (e.g., 1 1 1 2 1 2).}
#' @templateVar DETAILS_DATA_3 \item{"RT"}{Choice reaction time for the current trial, in \strong{seconds} (e.g., 0.435 0.383 0.314 0.309, etc.).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @description
#' Code for this model is based on codes/comments by Guido Biele, Joseph Burling, Andrew Ellis, and potential others @ Stan mailing
#'
#' Parameters of the DDM (parameter names in Ratcliff), from \url{https://github.com/gbiele/stan_wiener_test/blob/master/stan_wiener_test.R}
#' \cr - alpha (a): Boundary separation or Speed-accuracy trade-off (high alpha means high accuracy). 0 < alpha
#' \cr - beta (b): Initial bias, for either response (beta > 0.5 means bias towards "upper" response 'A'). 0 < beta < 1
#' \cr - delta (v): Drift rate; Quality of the stimulus (delta close to 0 means ambiguous stimulus or weak ability). 0 < delta
#' \cr - tau (ter): Non-decision time + Motor response time + encoding time (high means slow encoding, execution). 0 < tau (in seconds)
#'
#' @references
#' Ratcliff, R. (1978). A theory of memory retrieval. Psychological Review, 85(2), 59-108. http://doi.org/10.1037/0033-295X.85.2.59

choiceRT_ddm_single <- hBayesDM_model(
  task_name       = "choiceRT",
  model_name      = "ddm",
  model_type      = "single",
  data_columns    = c("subjID", "choice", "RT"),
  parameters      = list("alpha" = c(NA, 0.5, NA),
                         "beta"  = c(NA, 0.5, NA),
                         "delta" = c(NA, 0.5, NA),
                         "tau"   = c(NA, 0.15, NA)),
  postpreds       = NULL,
  preprocess_func = function(raw_data, general_info, RTbound = 0.1) {
    # Currently class(raw_data) == "data.table"

    # Data.tables for upper and lower boundary responses
    DT_upper <- raw_data[choice == 2]
    DT_lower <- raw_data[choice == 1]

    # Wrap into a list for Stan
    data_list <- list(
      Nu      = nrow(DT_upper),    # Number of upper boundary responses
      Nl      = nrow(DT_lower),    # Number of lower boundary responses
      RTu     = DT_upper$rt,       # Upper boundary response times
      RTl     = DT_lower$rt,       # Lower boundary response times
      minRT   = min(raw_data$rt),  # Minimum RT
      RTbound = RTbound            # Lower bound of RT (e.g., 0.1 second)
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

