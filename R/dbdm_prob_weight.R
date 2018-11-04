#' Description-based decision making task
#'
#' @description
#' Hierarchical Bayesian Modeling of the Description-based decision making task with the following parameters: "tau" (probability weight function), "rho" (subject utility fucntion), "lambda" (loss aversion parameter), and "beta" (inverse softmax temperature).
#'
#' \strong{MODEL:}
#' Probability weighting function (Erev et al., 2010; Hertwig et al., 2004; Jessup et al., 2008)
#'
#' @param data A .txt file containing the data to be modeled. Data columns should be labelled as follows: "subjID", "gain", "loss", "cert", and "gamble". See \bold{Details} below for more information.
#' @param niter Number of iterations, including warm-up.
#' @param nwarmup Number of iterations used for warm-up only.
#' @param nchain Number of chains to be run.
#' @param ncore Integer value specifying how many CPUs to run the MCMC sampling on. Defaults to 1.
#' @param nthin Every \code{i == nthin} sample will be used to generate the posterior distribution. Defaults to 1. A higher number can be used when auto-correlation within the MCMC sampling is high.
#' @param inits Character value specifying how the initial values should be generated. Options are "fixed" or "random" or your own initial values.
#' @param indPars Character value specifying how to summarize individual parameters. Current options are: "mean", "median", or "mode".
#' @param saveDir Path to directory where .RData file of model output (\code{modelData}) can be saved. Leave blank if not interested.
#' @param modelRegressor Exporting model-based regressors? TRUE or FALSE. Currently not available for this model.
#' @param vb             Use variational inference to approximately draw from a posterior distribution. Defaults to FALSE.
#' @param inc_postpred Include trial-level posterior predictive simulations in model output (may greatly increase file size). Defaults to FALSE.
#' @param adapt_delta Floating point number representing the target acceptance probability of a new sample in the MCMC chain. Must be between 0 and 1. See \bold{Details} below.
#' @param stepsize Integer value specifying the size of each leapfrog step that the MCMC sampler can take on each new iteration. See \bold{Details} below.
#' @param max_treedepth Integer value specifying how many leapfrog steps that the MCMC sampler can take on each new iteration. See \bold{Details} below.
#'
#' @return \code{modelData}  A class \code{"hBayesDM"} object with the following components:
#' \describe{
#'  \item{\code{model}}{Character string with the name of the model (\code{"dbdm_prob_weight"}).}
#'  \item{\code{allIndPars}}{\code{"data.frame"} containing the summarized parameter
#'    values (as specified by \code{"indPars"}) for each subject.}
#'  \item{\code{parVals}}{A \code{"list"} where each element contains posterior samples
#'    over different model parameters. }
#'  \item{\code{fit}}{A class \code{"stanfit"} object containing the fitted model.}
#'  \item{\code{rawdata}}{\code{"data.frame"} containing the raw data used to fit the model, as specified by the user.}
#' }
#'
#' @export
#'
#' @include hBayesDM_model.R
#' @importFrom data.table as.data.table
#'
#' @details
#' This section describes some of the function arguments in greater detail.
#'
#' \strong{data} should be assigned a character value specifying the full path and name of the file, including the file extension
#' (e.g. ".txt"), that contains the behavioral data of all subjects of interest for the current analysis.
#' The file should be a \strong{tab-delimited} text (.txt) file whose rows represent trial-by-trial observations and columns
#' represent variables. For the Description-based decision making task, there should be eight columns of data  with the labels
#' "subjID", "opt1hprob", "opt2hprob", "opt1hval", "opt1lval", "opt2hval", "opt2lval", and "choice". It is not necessary for the columns to be in this
#' particular order, however it is necessary that they be labelled correctly and contain the information below:
#' \describe{
#'  \item{\code{"subjID"}}{A unique identifier for each subject within data-set to be analyzed.}
#'  \item{\code{"opt1hprob"}}{Possiblity of getting higher value of outcome(opt1hval) when choosing option 1.}
#'  \item{\code{"opt2hprob"}}{Possiblity of getting higher value of outcome(opt2hval) when choosing option 2.}
#'  \item{\code{"opt1hval"}}{Possible (with opt1hprob probability) outcome of option 1}
#'  \item{\code{"opt1lval"}}{Possible (with (1-opt1hprob) probability) outcome of option 1}
#'  \item{\code{"opt2hval"}}{Possible (with opt2hprob probability) outcome of option 2}
#'  \item{\code{"opt2lval"}}{Possible (with (1-opt2hprob) probability) outcome of option 2}
#'  \item{\code{"choice"}}{If option1 was taken, choice == 1, else choice == 2.}
#' }
#' \strong{*}Note: The data.txt file may contain other columns of data (e.g. "Reaction_Time", "trial_number", etc.), but only the data with the column
#' names listed above will be used for analysis/modeling. As long as the columns above are present and labelled correctly,
#' there is no need to remove other miscellaneous data columns.
#'
#' \strong{nwarmup} is a numerical value that specifies how many MCMC samples should not be stored upon the
#' beginning of each chain. For those familiar with Bayesian methods, this value is equivalent to a burn-in sample.
#' Due to the nature of MCMC sampling, initial values (where the sampling chain begins) can have a heavy influence
#' on the generated posterior distributions. The \code{nwarmup} argument can be set to a high number in order to curb the
#' effects that initial values have on the resulting posteriors.
#'
#' \strong{nchain} is a numerical value that specifies how many chains (i.e. independent sampling sequences) should be
#' used to draw samples from the posterior distribution. Since the posteriors are generated from a sampling
#' process, it is good practice to run multiple chains to ensure that a representative posterior is attained. When
#' sampling is completed, the multiple chains may be checked for convergence with the \code{plot(myModel, type = "trace")}
#' command. The chains should resemble a "furry caterpillar".
#'
#' \strong{nthin} is a numerical value that specifies the "skipping" behavior of the MCMC samples being chosen
#' to generate the posterior distributions. By default, \code{nthin} is equal to 1, hence every sample is used to
#' generate the posterior.
#'
#' \strong{Contol Parameters:} adapt_delta, stepsize, and max_treedepth are advanced options that give the user more control
#' over Stan's MCMC sampler. The Stan creators recommend that only advanced users change the default values, as alterations
#' can profoundly change the sampler's behavior. Refer to Hoffman & Gelman (2014, Journal of Machine Learning Research) for
#' more information on the functioning of the sampler control parameters. One can also refer to section 58.2 of the
#' \href{http://mc-stan.org/documentation/}{Stan User's Manual} for a less technical description of these arguments.
#'
#' @references
#' Erev, I., Ert, E., Roth, A. E., Haruvy, E., Herzog, S. M., Hau, R., ... & Lebiere, C. (2010). A choice prediction competition: Choices from experience and from description.
#' Journal of Behavioral Decision Making, 23(1), 15-47.
#'
#' Hertwig, R., Barron, G., Weber, E. U., & Erev, I. (2004). Decisions from experience and the effect of rare events in risky choice.
#' Psychological science, 15(8), 534-539.
#'
#' Jessup, R. K., Bishara, A. J., & Busemeyer, J. R. (2008). Feedback produces divergence from prospect theory in descriptive choice.
#' Psychological Science, 19(10), 1015-1022.
#'
#'
#' @seealso
#' We refer users to our in-depth tutorial for an example of using hBayesDM: \url{https://rpubs.com/CCSL/hBayesDM}
#'
#' @examples
#' \dontrun{
#' # Run the model and store results in "output"
#' output <- ra2_prob_weight(data = "example", niter = 2000, nwarmup = 1000, nchain = 3, ncore = 3)
#'
#' # Visually check convergence of the sampling chains (should like like 'hairy caterpillars')
#' plot(output, type = 'trace')
#'
#' # Check Rhat values (all Rhat values should be less than or equal to 1.1)
#' rhat(output)
#'
#' # Plot the posterior distributions of the hyper-parameters (distributions should be unimodal)
#' plot(output)
#'
#' # Show the WAIC and LOOIC model fit estimates
#' printFit(output)
#' }

dbdm_prob_weight <- hBayesDM_model(
  task_name             = "dbdm",
  model_name            = "prob_weight",
  model_type            = "",
  data_columns          = c("subjID","opt1hprob","opt2hprob","opt1hval","opt1lval","opt2hval","opt2lval","choice"),
  parameters            = list("tau" = c(0, 0.8, 2),
                               "rho" = c(0, 0.7, 1),
                               "lambda" = c(0,2.5,5),
                               "beta" = c(0, 0.2, 1)),
  preprocess_func = function(raw_data, general_info) {
    DT      <- as.data.table(raw_data)
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    opt1hprob  <- array( 0, c(n_subj, t_max))
    opt2hprob  <- array( 0, c(n_subj, t_max))
    opt1hval  <- array( 0, c(n_subj, t_max))
    opt1lval  <- array( 0, c(n_subj, t_max))
    opt2hval  <- array( 0, c(n_subj, t_max))
    opt2lval  <- array( 0, c(n_subj, t_max))
    choice <- array( -1, c(n_subj, t_max))

    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- DT[subjid == subj]

      opt1hprob[i, 1:t] <- DT_subj$opt1hprob
      opt2hprob[i, 1:t] <- DT_subj$opt2hprob
      opt1hval[i, 1:t] <- DT_subj$opt1hval
      opt1lval[i, 1:t] <- DT_subj$opt1lval
      opt2hval[i, 1:t] <- DT_subj$opt2hval
      opt2lval[i, 1:t] <- DT_subj$opt2lval
      choice[i, 1:t] <- DT_subj$choice
    }

    data_list <- list(
      N = n_subj,
      T = t_max,
      Tsubj = t_subjs,
      opt1hprob = opt1hprob,
      opt2hprob = opt2hprob,
      opt1hval = opt1hval,
      opt1lval = opt1lval,
      opt2hval = opt2hval,
      opt2lval = opt2lval,
      choice = choice
      )

    return(data_list)
  }
)
