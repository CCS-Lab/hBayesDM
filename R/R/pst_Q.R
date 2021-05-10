#' @templateVar MODEL_FUNCTION pst_Q
#' @templateVar CONTRIBUTOR \href{https://www.unige.ch/fapse/e3lab/members1/phd-candidates/david-munoz-tord}{David Munoz Tord} <\email{david.munoztord@@unige.ch}>
#' @templateVar TASK_NAME Probabilistic Selection Task
#' @templateVar TASK_CODE pst
#' @templateVar TASK_CITE 
#' @templateVar MODEL_NAME Q Learning Model
#' @templateVar MODEL_CODE Q
#' @templateVar MODEL_CITE (Frank et al., 2007)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "type", "choice", "reward"
#' @templateVar PARAMETERS \code{alpha} (learning rate), \code{beta} (inverse temperature)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred"
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{type}{Two-digit number indicating which pair of stimuli were presented for that trial, e.g. 12, 34, or 56. The digit on the left (tens-digit) indicates the presented stimulus for option1, while the digit on the right (ones-digit) indicates that for option2. Code for each stimulus type (1~6) is defined as for 80\% (type 1), 20\% (type 2), 70\% (type 3), 30\% (type 4), 60\% (type 5), 40\% (type 6). The modeling will still work even if different probabilities are used for the stimuli; however, the total number of stimuli should be less than or equal to 6.}
#' @templateVar DETAILS_DATA_3 \item{choice}{Whether the subject chose the left option (option1) out of the given two options (i.e. if option1 was chosen, 1; if option2 was chosen, 0).}
#' @templateVar DETAILS_DATA_4 \item{reward}{Amount of reward earned as a result of the trial.}
#' @templateVar LENGTH_ADDITIONAL_ARGS 0
#' 
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Frank, M. J., Moustafa, A. A., Haughey, H. M., Curran, T., & Hutchison, K. E. (2007). Genetic triple dissociation reveals multiple roles for dopamine in reinforcement learning. Proceedings of the National Academy of Sciences, 104(41), 16311-16316.
#'


pst_Q <- hBayesDM_model(
  task_name       = "pst",
  model_name      = "Q",
  model_type      = "",
  data_columns    = c("subjID", "type", "choice", "reward"),
  parameters      = list(
    "alpha" = c(0, 0.5, 1),
    "beta" = c(0, 1, 10)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred"),
  preprocess_func = pst_preprocess_func)
