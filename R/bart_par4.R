#' @templateVar MODEL_FUNCTION bart_par4
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park}, \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang}, \href{https://ccs-lab.github.io/team/ayoung-lee/}{Ayoung Lee}, \href{https://ccs-lab.github.io/team/jeongbin-oh/}{Jeongbin Oh}, \href{https://ccs-lab.github.io/team/jiyoon-lee/}{Jiyoon Lee}, \href{https://ccs-lab.github.io/team/junha-jang/}{Junha Jang}
#' @templateVar TASK_NAME Balloon Analogue Risk Task
#' @templateVar TASK_CITE (Ravenzwaaij et al., 2011, Journal of Mathematical Psychology)
#' @templateVar MODEL_NAME Re-parameterized version (by Harhim Park & Jaeyeong Yang) of BART Model (Ravenzwaaij et al., 2011) with 4 parameters
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "pumps", "explosion"
#' @templateVar PARAMETERS "phi" (prior belief of balloon not bursting), "eta" (updating rate), "gam" (risk-taking parameter), "tau" (inverse temperature)
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"pumps"}{The number of pumps.}
#' @templateVar DETAILS_DATA_3 \item{"explosion"}{0: intact, 1: burst}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' van Ravenzwaaij, D., Dutilh, G., & Wagenmakers, E. J. (2011). Cognitive model decomposition of the
#'   BART: Assessment and application. Journal of Mathematical Psychology, 55(1), 94-105.

bart_par4 <- hBayesDM_model(
  task_name       = "bart",
  model_name      = "par4",
  data_columns    = c("subjID", "pumps", "explosion"),
  parameters      = list("phi" = c(0, 0.5, 1),
                         "eta" = c(0, 1, Inf),
                         "gam" = c(0, 1, Inf),
                         "tau" = c(0, 1, Inf)),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    pumps     <- array(0, c(n_subj, t_max))
    explosion <- array(0, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      pumps[i, 1:t]     <- DT_subj$pumps
      explosion[i, 1:t] <- DT_subj$explosion
    }

    # Wrap into a list for Stan
    data_list <- list(
      N         = n_subj,
      T         = t_max,
      Tsubj     = t_subjs,
      P         = max(pumps) + 1,
      pumps     = pumps,
      explosion = explosion
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

