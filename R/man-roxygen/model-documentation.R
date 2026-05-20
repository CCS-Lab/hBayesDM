#' @title <%= MODEL_NAME %>
#'
#' @description
#' <% .task_name <- get0("TASK_NAME", ifnotfound = NA) %>
#' <% .task_cite <- get0("TASK_CITE", ifnotfound = NA) %>
#' <% .model_cite <- get0("MODEL_CITE", ifnotfound = NA) %>
#' <%= MODEL_TYPE %> Bayesian Modeling<%= ifelse(!is.na(.task_name), paste0(" of the ", .task_name), "") %> using <%= MODEL_NAME %>.
#' It has the following parameters: <%= PARAMETERS %>.
#'
#' \itemize{
#'   <%= ifelse(!is.na(.task_name), paste0("\\item \\strong{Task}: ", .task_name, " ", ifelse(!is.na(.task_cite), .task_cite, "")), "") %>
#'   \item \strong{Model}: <%= MODEL_NAME %> <%= ifelse(!is.na(.model_cite), .model_cite, '') %>
#' }
#'
#' @param data Data to be modeled. It should be given as a data.frame object,
#'   a filepath for a tab-seperated txt file, \code{"example"} to use example data, or
#'   \code{"choose"} to choose data with an interactive window.
#'   Columns in the dataset must include:
#'   <%= DATA_COLUMNS %>. See \bold{Details} below for more information.
#' @param niter Number of iterations, including warm-up. Defaults to 4000.
#' @param nwarmup Number of iterations used for warm-up only. Defaults to 1000.
#' @param nchain Number of Markov chains to run. Defaults to 4.
#' @param ncore Number of CPUs to be used for running. Defaults to 1.
#' @param nthin Every \code{i == nthin} sample will be used to generate the posterior distribution.
#'   Defaults to 1. A higher number can be used when auto-correlation within the MCMC sampling is
#'   high.
#' @param inits Character value specifying how the initial values should be generated.
#'   Possible options are "vb" (default), "fixed", "random", or your own initial values.
#' @param ind_pars Character value specifying how to summarize individual parameters. Current options
#'   are: "mean", "median", or "mode".
#' @param model_regressor
#'   <% .regressors <- get0("REGRESSORS", ifnotfound = NA) %>
#'   <% EXISTS_REGRESSORS <- paste0("For this model they are: ", .regressors, ".") %>
#'   <% NOT_EXISTS_REGRESSORS <- "Not available for this model." %>
#'   Whether to export model-based regressors (\code{TRUE} or \code{FALSE}).
#'   <%= ifelse(!is.na(.regressors), EXISTS_REGRESSORS, NOT_EXISTS_REGRESSORS) %>
#' @param vb Use variational inference to approximately draw from a posterior distribution. Defaults
#'   to \code{FALSE}.
#' @param inc_postpred
#'   <% .postpreds <- get0("POSTPREDS", ifnotfound = NA) %>
#'   <% HAS_POSTPREDS <- !is.na(.postpreds) %>
#'   <% PP_T <- paste0("If set to \\code{TRUE}, it includes: ", .postpreds) %>
#'   <% PP_F <- "Not available for this model." %>
#'   Include trial-level posterior predictive simulations in model output (may greatly increase file
#'   size). Defaults to \code{FALSE}.
#'   <%= ifelse(HAS_POSTPREDS, PP_T, PP_F) %>
#' @param adapt_delta Floating point value representing the target acceptance probability of a new
#'   sample in the MCMC chain. Must be between 0 and 1. See \bold{Details} below.
#' @param stepsize Integer value specifying the size of each leapfrog step that the MCMC sampler can
#'   take on each new iteration. See \bold{Details} below.
#' @param max_treedepth Integer value specifying how many leapfrog steps the MCMC sampler can take
#'   on each new iteration. See \bold{Details} below.
#' @param seed Integer seed used for MCMC sampling and (when applicable) variational inference, to
#'   make results reproducible. Defaults to \code{42}.
#' @param ...
#'   <% AA_T1 <- "For this model, it's possible to set \\strong{model-specific argument(s)} " %>
#'   <% AA_T2 <- "as follows: " %>
#'   <% AA_T <- paste0(AA_T1, AA_T2) %>
#'   <% AA_F <- "For this model, there is no model-specific argument." %>
#'   <%= ifelse(as.integer(LENGTH_ADDITIONAL_ARGS) > 0, AA_T, AA_F) %>
#'   <%= ifelse(as.integer(LENGTH_ADDITIONAL_ARGS) > 0, "\\describe{", "") %>
#'     <%= get0("ADDITIONAL_ARGS_1") %>
#'     <%= get0("ADDITIONAL_ARGS_2") %>
#'     <%= get0("ADDITIONAL_ARGS_3") %>
#'     <%= get0("ADDITIONAL_ARGS_4") %>
#'     <%= get0("ADDITIONAL_ARGS_5") %>
#'     <%= get0("ADDITIONAL_ARGS_6") %>
#'     <%= get0("ADDITIONAL_ARGS_7") %>
#'     <%= get0("ADDITIONAL_ARGS_8") %>
#'     <%= get0("ADDITIONAL_ARGS_9") %>
#'   <%= ifelse(as.integer(LENGTH_ADDITIONAL_ARGS) > 0, "}", "") %>
#'
#' @return A class "hBayesDM" object \code{model_data} with the following components:
#' \describe{
#'   \item{model}{Character value that is the name of the model (\code{"<%= MODEL_FUNCTION %>"}).}
#'   \item{all_ind_pars}{Data.frame containing the summarized parameter values (as specified by
#'     \code{ind_pars}) for each subject.}
#'   \item{par_vals}{List object containing the posterior samples over different parameters.}
#'   \item{fit}{A \code{CmdStanMCMC} object (or \code{CmdStanVB} when \code{vb = TRUE})
#'     produced by \pkg{cmdstanr}. Use \code{fit$draws()}, \code{fit$summary()}, etc. to
#'     interact with the posterior; see \pkg{cmdstanr} documentation for details.}
#'   \item{raw_data}{Data.frame containing the raw data used to fit the model, as specified by
#'     the user.}
#'   <% RETURN_REGRESSORS <- "\\item{model_regressor}{List object containing the " %>
#'   <% RETURN_REGRESSORS <- paste0(RETURN_REGRESSORS, "extracted model-based regressors.}") %>
#'   <%= ifelse(!is.na(.regressors), RETURN_REGRESSORS, "") %>
#' }
#'
#' @details
#' This section describes some of the function arguments in greater detail.
#'
#' \strong{data} should be assigned a character value specifying the full path and name (including
#'   extension information, e.g. ".txt") of the file that contains the behavioral data-set of all
#'   subjects of interest for the current analysis. The file should be a \strong{tab-delimited} text
#'   file, whose rows represent trial-by-trial observations and columns represent variables.\cr
#' For the <%= ifelse(!is.na(.task_name), .task_name, MODEL_NAME) %>, there should be <%= LENGTH_DATA_COLUMNS %> columns of data with the
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
#'   possible to check the multiple chains for convergence by running the following line of code:
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
#'   Algorithm Parameters' of the \href{https://mc-stan.org/users/documentation/}{Stan User's Guide
#'   and Reference Manual}, or to the help pages for \code{cmdstanr::sample()} for a less
#'   technical description of these arguments.
#'
#' \strong{First-fit compile cost:} hBayesDM 2.0 compiles each Stan model on first use via
#'   \pkg{cmdstanr} (no install-time precompile). Expect a one-time ~30s wait per model;
#'   subsequent fits reuse the cached binary.
#'
#' <% .contributor <- get0("CONTRIBUTOR", ifnotfound = NA) %>
#' <%= ifelse(!is.na(.contributor), paste0("\\subsection{Contributors}{", .contributor, "}"), "") %>
#'
#' @seealso
#' We refer users to our in-depth tutorial for an example of using hBayesDM:
#'   \url{https://rpubs.com/CCSL/hBayesDM}
#'
#' @examples
#' \dontrun{
#' # Run the model with a given data.frame as df
#' output <- <%= MODEL_FUNCTION %>(
#'   data = df, niter = 2000, nwarmup = 1000, nchain = 4, ncore = 4)
#'
#' # Run the model with example data
#' output <- <%= MODEL_FUNCTION %>(
#'   data = "example", niter = 2000, nwarmup = 1000, nchain = 4, ncore = 4)
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
#' print_fit(output)
#' }
