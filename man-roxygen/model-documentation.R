#' @title <%= TASK_NAME %> <%= get0("TASK_CITE") %>
#'
#' @description
#' <%= MODEL_TYPE %> Bayesian Modeling of the <%= TASK_NAME %> with the following parameters:
#'   <%= PARAMETERS %>.
#'
#' <%= ifelse(exists("CONTRIBUTOR"), paste0("@description Contributor: ", CONTRIBUTOR), "") %>
#'
#' @description
#' \strong{MODEL:} <%= MODEL_NAME %> <%= get0("MODEL_CITE") %>
#'
#' @include hBayesDM_model.R
#'
#' @param data A .txt file containing the data to be modeled. Data columns should be labeled as:
#'   <%= DATA_COLUMNS %>. See \bold{Details} below for more information.
#' @param niter Number of iterations, including warm-up. Defaults to 4000.
#' @param nwarmup Number of iterations used for warm-up only. Defaults to 1000.
#' @param nchain Number of Markov chains to run. Defaults to 4.
#' @param ncore Number of CPUs to be used for running. Defaults to 1.
#' @param nthin Every \code{i == nthin} sample will be used to generate the posterior distribution.
#'   Defaults to 1. A higher number can be used when auto-correlation within the MCMC sampling is
#'   high.
#' @param inits Character value specifying how the initial values should be generated. Options are
#'   "fixed" or "random", or your own initial values.
#' @param indPars Character value specifying how to summarize individual parameters. Current options
#'   are: "mean", "median", or "mode".
#' @param modelRegressor
#'   <% EXISTS_REGRESSORS <- paste0("Regressors for this model are: ", get0("REGRESSORS"), ".") %>
#'   <% NOT_EXISTS_REGRESSORS <- "Currently not available for this model." %>
#'   Export model-based regressors? TRUE or FALSE.
#'   <%= ifelse(exists("REGRESSORS"), EXISTS_REGRESSORS, NOT_EXISTS_REGRESSORS) %>
#' @param vb Use variational inference to approximately draw from a posterior distribution. Defaults
#'   to FALSE.
#' @param inc_postpred
#'   <% EXISTS_IS_NULL_POSTPREDS_AND_TRUE <- exists("IS_NULL_POSTPREDS") && IS_NULL_POSTPREDS %>
#'   <%= ifelse(EXISTS_IS_NULL_POSTPREDS_AND_TRUE, "\\strong{(Currently not available.)}", "") %>
#'   Include trial-level posterior predictive simulations in model output (may greatly increase file
#'   size). Defaults to FALSE.
#' @param adapt_delta Floating point value representing the target acceptance probability of a new
#'   sample in the MCMC chain. Must be between 0 and 1. See \bold{Details} below.
#' @param stepsize Integer value specifying the size of each leapfrog step that the MCMC sampler can
#'   take on each new iteration. See \bold{Details} below.
#' @param max_treedepth Integer value specifying how many leapfrog steps the MCMC sampler can take
#'   on each new iteration. See \bold{Details} below.
#'
#' @details
#' This section describes some of the function arguments in greater detail.
#'
#' \strong{data} should be assigned a character value specifying the full path and name (including
#'   extension information, e.g. ".txt") of the file that contains the behavioral data-set of all
#'   subjects of interest for the current analysis. The file should be a \strong{tab-delimited} text
#'   file, whose rows represent trial-by-trial observations and columns represent variables.\cr
#' For the <%= TASK_NAME %>, there should be <%= LENGTH_DATA_COLUMNS %> columns of data with the
#'   labels <%= DATA_COLUMNS %>. It is not necessary for the columns to be in this particular order,
#'   however it is necessary that they be labeled correctly and contain the information below:
#' \describe{
#'   <%= DETAILS_DATA_1 %>
#'   <%= get0("DETAILS_DATA_2") %>
#'   <%= get0("DETAILS_DATA_3") %>
#'   <%= get0("DETAILS_DATA_4") %>
#'   <%= get0("DETAILS_DATA_5") %>
#'   <%= get0("DETAILS_DATA_6") %>
#'   <%= get0("DETAILS_DATA_7") %>
#'   <%= get0("DETAILS_DATA_8") %>
#'   <%= get0("DETAILS_DATA_9") %>
#' }
#' \strong{*}Note: The file may contain other columns of data (e.g. "ReactionTime", "trial_number",
#'   etc.), but only the data within the column names listed above will be used during the modeling.
#'   As long as the necessary columns mentioned above are present and labeled correctly, there is no
#'   need to remove other miscellaneous data columns.
#'
#' \strong{nwarmup} is a numerical value that specifies how many MCMC samples should not be stored
#'   upon the beginning of each chain. For those familiar with Bayesian methods, this is equivalent
#'   to burn-in samples. Due to the nature of the MCMC algorithm, initial values (i.e. where the
#'   sampling chains begin) can have a heavy influence on the generated posterior distributions. The
#'   \code{nwarmup} argument can be set to a high number in order to curb the effects that initial
#'   values have on the resulting posteriors.
#'
#' \strong{nchain} is a numerical value that specifies how many chains (i.e. independent sampling
#'   sequences) should be used to draw samples from the posterior distribution. Since the posteriors
#'   are generated from a sampling process, it is good practice to run multiple chains to ensure
#'   that a reasonably representative posterior is attained. When the sampling is complete, it is
#'   possible to check the multiple chains for convergence by running the following piece of code:
#'   \code{plot(output, type = "trace")}. The trace-plot should resemble a "furry caterpillar".
#'
#' \strong{nthin} is a numerical value that specifies the "skipping" behavior of the MCMC sampler,
#'   using only every \code{i == nthin} samples to generate posterior distributions. By default,
#'   \code{nthin} is equal to 1, meaning that every sample is used to generate the posterior.
#'
#' \strong{Control Parameters:} \code{adapt_delta}, \code{stepsize}, and \code{max_treedepth} are
#'   advanced options that give the user more control over Stan's MCMC sampler. It is recommended
#'   that only advanced users change the default values, as alterations can profoundly change the
#'   sampler's behavior. Refer to 'The No-U-Turn Sampler: Adaptively Setting Path Lengths in
#'   Hamiltonian Monte Carlo (Hoffman & Gelman, 2014, Journal of Machine Learning Research)' for
#'   more information on the sampler control parameters. One can also refer to 'Section 34.2. HMC
#'   Algorithm Parameters' of the \href{http://mc-stan.org/users/documentation/}{Stan User's Guide
#'   and Reference Manual}, or to the help page for \code{\link[rstan]{stan}} for a less technical
#'   description of these arguments.
#'
#' @return A class "hBayesDM" object \code{modelData} with the following components:
#' \describe{
#'   \item{\code{model}}{Character value that is the name of the model ("<%= MODEL_FUNCTION %>").}
#'   \item{\code{allIndPars}}{Data.frame containing the summarized parameter values (as specified by
#'     \code{indPars}) for each subject.}
#'   \item{\code{parVals}}{List object where each element contains posterior samples over different
#'     model parameters.}
#'   \item{\code{fit}}{A class \code{\link[rstan]{stanfit}} object that contains the fitted Stan
#'     model.}
#'   \item{\code{rawdata}}{Data.frame containing the raw data used to fit the model, as specified by
#'     the user.}
#' }
#'
#' @seealso
#' We refer users to our in-depth tutorial for an example of using hBayesDM:
#'   \url{https://rpubs.com/CCSL/hBayesDM}
#'
#' @examples
#' # Run the model and store results in "output"
#' output <- <%= MODEL_FUNCTION %>("example", niter = 2000, nwarmup = 1000, nchain = 4, ncore = 4)
#'
#' # Visually check convergence of the sampling chains (should look like 'hairy caterpillars')
#' plot(output, type = "trace")
#'
#' # Check Rhat values (all Rhat values should be less than or equal to 1.1)
#' rhat(output)
#'
#' # Plot the posterior distributions of the hyper-parameters (distributions should be unimodal)
#' plot(output)
#'
#' # Show the WAIC and LOOIC model fit estimates
#' printFit(output)
