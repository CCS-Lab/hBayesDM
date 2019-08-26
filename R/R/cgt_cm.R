#' @templateVar MODEL_FUNCTION cgt_cm
#' @templateVar CONTRIBUTOR \href{http://haines-lab.com/}{Nathaniel Haines} <\email{haines.175@@osu.edu}>
#' @templateVar TASK_NAME Cambridge Gambling Task
#' @templateVar TASK_CODE cgt
#' @templateVar TASK_CITE (Rogers et al., 1999)
#' @templateVar MODEL_NAME Cumulative Model
#' @templateVar MODEL_CODE cm
#' @templateVar MODEL_CITE 
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "gamble_type", "percentage_staked", "trial_initial_points", "assessment_stage", "left_colour_chosen", "n_left_colour_boxes"
#' @templateVar PARAMETERS \code{alpha} (probability distortion), \code{c} (color bias), \code{rho} (relative loss sensitivity), \code{beta} (discounting rate), \code{gamma} (choice sensitivity)
#' @templateVar REGRESSORS "y_hat_col", "y_hat_bet", "bet_utils"
#' @templateVar POSTPREDS 
#' @templateVar LENGTH_DATA_COLUMNS 7
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{gamble_type}{}
#' @templateVar DETAILS_DATA_3 \item{percentage_staked}{}
#' @templateVar DETAILS_DATA_4 \item{trial_initial_points}{}
#' @templateVar DETAILS_DATA_5 \item{assessment_stage}{}
#' @templateVar DETAILS_DATA_6 \item{left_colour_chosen}{}
#' @templateVar DETAILS_DATA_7 \item{n_left_colour_boxes}{}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R
#' 
#' @references
#' Rogers, R. D., Everitt, B. J., Baldacchino, A., Blackshaw, A. J., Swainson, R., Wynne, K., Baker, N. B., Hunter, J., Carthy, T., London, M., Deakin, J. F. W., Sahakian, B. J., Robbins, T. W. (1999). Dissociable deficits in the decision-making cognition of chronic amphetamine abusers, opiate abusers, patients with focal damage to prefrontal cortex, and tryptophan-depleted normal volunteers: evidence for monoaminergic mechanisms. Neuropsychopharmacology, 20, 322–339.

#'

cgt_cm <- hBayesDM_model(
  task_name       = "cgt",
  model_name      = "cm",
  model_type      = "",
  data_columns    = c("subjID", "gamble_type", "percentage_staked", "trial_initial_points", "assessment_stage", "left_colour_chosen", "n_left_colour_boxes"),
  parameters      = list(
    "alpha" = c(0, 1, 5),
    "c" = c(0, 0.5, 1),
    "rho" = c(0, 1, Inf),
    "beta" = c(0, 1, Inf),
    "gamma" = c(0, 1, Inf)
  ),
  regressors      = list(
    "y_hat_col" = 2,
    "y_hat_bet" = 2,
    "bet_utils" = 3
  ),
  postpreds       = NULL,
  preprocess_func = cgt_preprocess_func)
