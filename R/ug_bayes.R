#' @templateVar MODEL_FUNCTION ug_bayes
#' @templateVar TASK_NAME Norm-Training Ultimatum Game
#' @templateVar MODEL_NAME Ideal Observer Model
#' @templateVar MODEL_CITE (Xiang et al., 2013, J Neuro)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "offer", "accept"
#' @templateVar PARAMETERS "alpha" (envy), "beta" (guilt), "tau" (inverse temperature)
#' @templateVar LENGTH_DATA_COLUMNS 3
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"offer"}{Floating point value representing the offer made in that trial (e.g. 4, 10, 11).}
#' @templateVar DETAILS_DATA_3 \item{"accept"}{1 or 0, indicating whether the offer was accepted in that trial (where accepted == 1, rejected == 0).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @references
#' Xiang, T., Lohrenz, T., & Montague, P. R. (2013). Computational Substrates of Norms and Their
#'   Violations during Social Exchange. Journal of Neuroscience, 33(3), 1099-1108.
#'   http://doi.org/10.1523/JNEUROSCI.1642-12.2013

ug_bayes <- hBayesDM_model(
  task_name       = "ug",
  model_name      = "bayes",
  data_columns    = c("subjID", "offer", "accept"),
  parameters      = list("alpha" = c(0, 1, 20),
                         "beta"  = c(0, 0.5, 10),
                         "tau"   = c(0, 1, 10)),
  preprocess_func = function(raw_data, general_info) {
    # Currently class(raw_data) == "data.table"

    # Use general_info of raw_data
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    # Initialize (model-specific) data arrays
    offer  <- array( 0, c(n_subj, t_max))
    accept <- array(-1, c(n_subj, t_max))

    # Write from raw_data to the data arrays
    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- raw_data[subjid == subj]

      offer[i, 1:t]  <- DT_subj$offer
      accept[i, 1:t] <- DT_subj$accept
    }

    # Wrap into a list for Stan
    data_list <- list(
      N      = n_subj,
      T      = t_max,
      Tsubj  = t_subjs,
      offer  = offer,
      accept = accept
    )

    # Returned data_list will directly be passed to Stan
    return(data_list)
  }
)

