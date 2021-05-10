#' @templateVar MODEL_FUNCTION ts_par4
#' @templateVar CONTRIBUTOR \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park} <\email{hrpark12@@gmail.com}>
#' @templateVar TASK_NAME Two-Step Task
#' @templateVar TASK_CODE ts
#' @templateVar TASK_CITE (Daw et al., 2011)
#' @templateVar MODEL_NAME Hybrid Model, with 4 parameters
#' @templateVar MODEL_CODE par4
#' @templateVar MODEL_CITE (Daw et al., 2011; Wunderlich et al., 2012)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "level1_choice", "level2_choice", "reward"
#' @templateVar PARAMETERS \code{a} (learning rate for both stages 1 & 2), \code{beta} (inverse temperature for both stages 1 & 2), \code{pi} (perseverance), \code{w} (model-based weight)
#' @templateVar REGRESSORS 
#' @templateVar POSTPREDS "y_pred_step1", "y_pred_step2"
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{subjID}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{level1_choice}{Choice made for Level (Stage) 1 (1: stimulus 1, 2: stimulus 2).}
#' @templateVar DETAILS_DATA_3 \item{level2_choice}{Choice made for Level (Stage) 2 (1: stimulus 3, 2: stimulus 4, 3: stimulus 5, 4: stimulus 6).\cr        Note that, in our notation, choosing stimulus 1 in Level 1 leads to stimulus 3 & 4 in Level 2 with a common (0.7 by default) transition. Similarly, choosing stimulus 2 in Level 1 leads to stimulus 5 & 6 in Level 2 with a common (0.7 by default) transition. To change this default transition probability, set the function argument `trans_prob` to your preferred value.}
#' @templateVar DETAILS_DATA_4 \item{reward}{Reward after Level 2 (0 or 1).}
#' @templateVar LENGTH_ADDITIONAL_ARGS 1
#' @templateVar ADDITIONAL_ARGS_1 \item{trans_prob}{Common state transition probability from Stage (Level) 1 to Stage (Level) 2. Defaults to 0.7.}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#' @include preprocess_funcs.R

#' @references
#' Daw, N. D., Gershman, S. J., Seymour, B., Ben Seymour, Dayan, P., & Dolan, R. J. (2011). Model-Based Influences on Humans' Choices and Striatal Prediction Errors. Neuron, 69(6), 1204-1215. https://doi.org/10.1016/j.neuron.2011.02.027
#'
#' Daw, N. D., Gershman, S. J., Seymour, B., Ben Seymour, Dayan, P., & Dolan, R. J. (2011). Model-Based Influences on Humans' Choices and Striatal Prediction Errors. Neuron, 69(6), 1204-1215. https://doi.org/10.1016/j.neuron.2011.02.027
#'
#' Wunderlich, K., Smittenaar, P., & Dolan, R. J. (2012). Dopamine enhances model-based over model-free choice behavior. Neuron, 75(3), 418-424.
#'


ts_par4 <- hBayesDM_model(
  task_name       = "ts",
  model_name      = "par4",
  model_type      = "",
  data_columns    = c("subjID", "level1_choice", "level2_choice", "reward"),
  parameters      = list(
    "a" = c(0, 0.5, 1),
    "beta" = c(0, 1, Inf),
    "pi" = c(0, 1, 5),
    "w" = c(0, 0.5, 1)
  ),
  regressors      = NULL,
  postpreds       = c("y_pred_step1", "y_pred_step2"),
  preprocess_func = ts_preprocess_func)
