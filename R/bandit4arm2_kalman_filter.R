#' 4-armed bandit task
#'
#' @description
#' Hierarchical Bayesian Modeling of the 4-armed bandit task with the following parameters: "lambda" (decay parameter), "theta" (decay center), "beta" (exploration parameter), "mu0" (initial expected mean payoff), "sigma0" (initial uncertainty), and "sigmaD" (the speed of diffusion in the payoffs).
#'
#' Contributor: \href{https://zohyos7.github.io}{Yoonseo Zoh}
#'
#' \strong{MODEL:}
#' Reinforcement Learning with Kalman Filter (Daw et al., 2006, Nature)
#'
#' @param data A .txt file containing the data to be modeled. Data columns should be labelled as follows: "subjID", "choice", "outcome". See \bold{Details} below for more information.
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
#'  \item{\code{model}}{Character string with the name of the model (\code{"bandit4arm2_kalman_filter"}).}
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
#' represent variables. For the 4-armed bandit task(2), there should be three columns of data with the labels
#' "subjID", "choice", and "outcome". It is not necessary for the columns to be in this
#' particular order, however it is necessary that they be labelled correctly and contain the information below:
#' \describe{
#'  \item{\code{"subjID"}}{A unique identifier for each subject within data-set to be analyzed.}
#'  \item{\code{"choice"}}{Should contain a integer value representing the chosen choice option within the given trial (e.g., 1 or 2 in 2-arm bandit task).}
#'  \item{\code{"outcome"}}{Should contain outcomes within each given trial (e.g., 1 = reward, -1 = loss).}
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
#' Daw, N. D., O'Doherty, J. P., Dayan, P., Seymour, B., & Dolan, R. J. (2006). Cortical substrates for exploratory decisions
#' in humans. Nature, 441(7095), 876-879.
#'
#' @seealso
#' We refer users to our in-depth tutorial for an example of using hBayesDM: \url{https://rpubs.com/CCSL/hBayesDM}
#'
#' @examples
#' \dontrun{
#' # Run the model and store results in "output"
#' output <- bandit4arm2_kalman_filter(data = "example", niter = 2000, nwarmup = 1000, nchain = 3, ncore = 3)
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
#'
#'
#' # Paths to data published in Sokol-Hessner et al. (2009)
#' path_to_attend_data = system.file("extdata/bandit4arm2_exampleData.txt", package = "hBayesDM")
#'
#' path_to_regulate_data = system.file("extdata/bandit4arm2_exampleData.txt, package = "hBayesDM")
#' }

bandit4arm2_kalman_filter <- hBayesDM_model(
  task_name             = "bandit4arm2",
  model_name            = "kalman_filter",
  model_type            = "",
  data_columns          = c("subjID", "trial", "choice", "outcome"),
  parameters            = list("lambda" = c(0, 0.9, 1),
                               "theta" = c(0, 50, 100),
                               "beta" = c(0,0.1,1),
                               "mu0" = c(0, 85, 150),
                               "sigma0" = c(0, 6, 20),
                               "sigmaD" = c(0, 3, 15)),
  regressors            = NULL,
  preprocess_func = function(raw_data, general_info) {
    DT      <- as.data.table(raw_data)
    subjs   <- general_info$subjs
    n_subj  <- general_info$n_subj
    t_subjs <- general_info$t_subjs
    t_max   <- general_info$t_max

    choice  <- array( -1, c(n_subj, t_max))
    outcome <- array(  0, c(n_subj, t_max))

    for (i in 1:n_subj) {
      subj <- subjs[i]
      t <- t_subjs[i]
      DT_subj <- DT[subjid == subj]

      choice[i, 1:t] <- DT_subj$choice
      outcome[i, 1:t] <-DT_subj$outcome
    }

    data_list <- list(
      N = n_subj,
      T = t_max,
      Tsubj = t_subjs,
      choice = choice,
      outcome = outcome
    )

    return(data_list)
  }
)
