#' Choice Reaction Time task, linear ballistic accumulator modeling
#'
#' @description
#' Individual Bayesian Modeling of choice/reaction time data with the following parameters: "d" (boundary), "A" (upper boundary of starting point), "v" (drift rate), "tau" (non-decision time).
#' The model published in Annis, J., Miller, B. J., & Palmeri, T. J. (2016). Bayesian inference with Stan: A tutorial on adding custom distributions. Behavior research methods, 1-24.
#'
#' \strong{MODEL:}
#' Brown and Heathcote LBA model - single subject. Note that this implementation estimates a different drift rate
#' for each condition-choice pair. For example, if the task involves deciding between two stimuli on each trial, and
#' there are two different conditions throughout the task (e.g. speed versus accuracy), a total of 4 (2 stimuli by 2 conditions)
#' drift rates will be estimated. For details on implementation, see Annis et al. (2016).
#'
#' @param data A .txt file containing the data to be modeled. Data columns should be labelled as follows: "subjID", "choice", "RT", and "condition". See \bold{Details} below for more information.
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
#' @return \code{modelData}  A class \code{'hBayesDM'} object with the following components:
#' \describe{
#'  \item{\code{model}}{Character string with the name of the model (\code{"choiceRT_lba_single"}).}
#'  \item{\code{allIndPars}}{\code{'data.frame'} containing the summarized parameter
#'    values (as specified by \code{'indPars'}) for each subject.}
#'  \item{\code{parVals}}{A \code{'list'} where each element contains posterior samples
#'    over different model parameters. }
#'  \item{\code{fit}}{A class \code{'stanfit'} object containing the fitted model.}
#'  \item{\code{rawdata}}{\code{"data.frame"} containing the raw data used to fit the model, as specified by the user.}
#' }
#'
#' @include settings.R
#' @importFrom rstan vb sampling stan_model rstan_options extract
#' @importFrom parallel detectCores
#' @importFrom stats median qnorm density
#' @importFrom utils read.table
#'
#' @details
#' This section describes some of the function arguments in greater detail.
#'
#' \strong{data} should be assigned a character value specifying the full path and name of the file, including the file extension
#' (e.g. ".txt"), that contains the behavioral data of all subjects of interest for the current analysis.
#' The file should be a \strong{tab-delimited} text (.txt) file whose rows represent trial-by-trial observations and columns
#' represent variables. For choice/reaction time tasks, there should be four columns of data
#' with the labels "choice", "RT", and "condition". It is not necessary for the columns to be in this particular order,
#' however it is necessary that they be labelled correctly and contain the information below:
#' \describe{
#'  \item{\code{"subjID"}}{A unique identifier for each subject within data-set to be analyzed.}
#'  \item{\code{"choice"}}{An integer representing the choice made on the current trial. (e.g., 1 1 3 2 1 2).}
#'  \item{\code{"RT"}}{A floating number the choice reaction time in \strong{seconds}. (e.g., 0.435 0.383 0.314 0.309, etc.).}
#'  \item{\code{"condition"}}{An integer representing the condition of the current trail (e.g., 1 2 3 4).}
#' }
#' \strong{*}Note: The data.txt file may contain other columns of data (e.g. "Reaction_Time", "trial_number", etc.), but only the data with the column
#' names listed above will be used for analysis/modeling. As long as the columns above are present and labelled correctly,
#' there is no need to remove other miscellaneous data columns.
#'
#' \strong{nwarmup} is a numerical value that specifies how many MCMC samples should not be stored upon the
#' beginning of each chain. For those familiar with Bayesian methods, this value is equivalent to a burn-in sample.
#' Due to the nature of MCMC sampling, initial values (where the sampling chain begins) can have a heavy influence
#' on the generated posterior distributions. The \strong{nwarmup} argument can be set to a high number in order to curb the
#' effects that initial values have on the resulting posteriors.
#'
#' \strong{nchain} is a numerical value that specifies how many chains (i.e. independent sampling sequences) should be
#' used to draw samples from the posterior distribution. Since the posteriors are generated from a sampling
#' process, it is good practice to run multiple chains to ensure that a representative posterior is attained. When
#' sampling is completed, the multiple chains may be checked for convergence with the \code{plot(myModel, type = "trace")}
#' command. The chains should resemble a "furry caterpillar".
#'
#' \strong{nthin} is a numerical value that specifies the "skipping" behavior of the MCMC samples being chosen
#' to generate the posterior distributions. By default, \strong{nthin} is equal to 1, hence every sample is used to
#' generate the posterior.
#'
#' \strong{Contol Parameters:} adapt_delta, stepsize, and max_treedepth are advanced options that give the user more control
#' over Stan's MCMC sampler. The Stan creators recommend that only advanced users change the default values, as alterations
#' can profoundly change the sampler's behavior. Refer to Hoffman & Gelman (2014, Journal of Machine Learning Research) for
#' more information on the functioning of the sampler control parameters. One can also refer to section 58.2 of the
#' \href{https://mc-stan.org/users/documentation/}{Stan User's Manual} for a less technical description of these arguments.
#'
#' @keywords internal
#'
#' @references
#' Brown, S. D., & Heathcote, A. (2008). The simplest complete model of choice response time: Linear ballistic accumulation.
#' Cognitive Psychology, 57(3), 153-178. http://doi.org/10.1016/j.cogpsych.2007.12.002
#'
#' Annis, J., Miller, B. J., & Palmeri, T. J. (2016). Bayesian inference with Stan: A tutorial on adding custom distributions.
#' Behavior research methods, 1-24.
#'
#' Hoffman, M. D., & Gelman, A. (2014). The No-U-turn sampler: adaptively setting path lengths in Hamiltonian Monte Carlo. The
#' Journal of Machine Learning Research, 15(1), 1593-1623.
#'
#' @seealso
#' We refer users to our in-depth tutorial for an example of using hBayesDM: \url{https://rpubs.com/CCSL/hBayesDM}
#'
#' @examples
#' \dontrun{
#' # Run the model and store results in "output"
#' output <- choiceRT_lba_single(data = "example", niter = 2000, nwarmup = 1000, nchain = 3, ncore = 3)
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

choiceRT_lba_single <- function(data           = "choose",
                                niter          = 3000,
                                nwarmup        = 1000,
                                nchain         = 2,
                                ncore          = 2,
                                nthin          = 1,
                                inits          = "random",
                                indPars        = "mean",
                                saveDir        = NULL,
                                modelRegressor = FALSE,
                                vb             = FALSE,
                                inc_postpred   = FALSE,
                                adapt_delta    = 0.95,
                                stepsize       = 1,
                                max_treedepth  = 10) {

  # Path to .stan model file
  if (modelRegressor) { # model regressors (for model-based neuroimaging, etc.)
    stop("** Model-based regressors are not available for this model **\n")
  }

  # To see how long computations take
  startTime <- Sys.time()

  # For using example data
  if (data == "example") {
    data <- system.file("extdata", "choiceRT_single_exampleData.txt", package = "hBayesDM")
  } else if (data == "choose") {
    data <- file.choose()
  }

  # Load data
  if (file.exists(data)) {
    rawdata <- read.table(data, header = T)
  } else {
    stop("** The data file does not exist. Please check it again. **\n  e.g., data = '/MyFolder/SubFolder/dataFile.txt', ... **\n")
  }

  # Individual Subjects
  subjID <- unique(rawdata[,"subjID"])  # list of subjects x blocks
  numSubjs <- length(subjID)  # number of subjects

  # Specify the number of parameters and parameters of interest
  numPars <- 4
  POI     <- c("d", "A", "v", "tau",
               "log_lik")

  if (inc_postpred) {
    POI <- c(POI, "y_pred")
  }

  # Boundary (d): Reparameterization of decision boundary, where boundary = d + A
  # Starting point (A): Upper boundary on starting point uniform distribution
  # Drift rate (v): Drift rate Quality of the stimulus (delta close to 0 means ambiguous stimulus or weak ability). 0 < delta
  # Nondecision Time (tau): Nondecision time + Motor response time + encoding time (high means slow encoding, execution). 0 < ter (in seconds)

  modelName <- "choiceRT_lba_single"

  # Information for user
  cat("\nModel name = ", modelName, "\n")
  cat("Data file  = ", data, "\n")
  cat("\nDetails:\n")
  if (vb) {
    cat(" # Using variational inference # \n")
  } else {
    cat(" # of chains                   = ", nchain, "\n")
    cat(" # of cores used               = ", ncore, "\n")
    cat(" # of MCMC samples (per chain) = ", niter, "\n")
    cat(" # of burn-in samples          = ", nwarmup, "\n")
  }
  cat(" # of subjects                 = ", numSubjs, "\n")

  ################################################################################
  # THE DATA.  ###################################################################
  ################################################################################

  # Setting number trial/subject
  Tsubj = dim(rawdata)[1]

  # Information for user continued
  cat(" # of (max) trials of this subject = ", Tsubj, "\n\n")

  # Number of different choices
  N_choice <- length(unique(rawdata$choice))

  # Number of different conditions (e.g. speed/accuracy)
  N_cond <- length(unique(rawdata$condition))

  # To store number of trials/condition for given subject
  tr_cond <- array(NA, dim = c(N_cond))
  # Loop through conditions
  for (j in 1:N_cond) {
    tr_cond[j] <- sum(rawdata$condition == j)
  }
  # Max trials across conditions
  max_tr <- max(tr_cond)

  # Array for storing RT + choice data
  RT <- array(-1, dim = c(N_cond, 2, max_tr))

  # Reaction time + choice matrix
  for (cond in 1:N_cond) {
    for (choice in 1:N_choice) {
      # Subset current data
      tmp <- subset(rawdata, rawdata$condition == cond & rawdata$choice == choice)
      # trials for current subject/condition pair
      tmp_trials <- tr_cond[cond]
      # Store reaction time + choice
      RT[cond, 1, 1:tmp_trials] <- tmp$RT
      RT[cond, 2, 1:tmp_trials] <- tmp$choice
    }
  }

  dataList <- list(
    N_choice = N_choice,
    N_cond   = N_cond,
    tr_cond  = tr_cond,
    max_tr   = max_tr,
    RT       = RT
)

  # inits
  if (inits[1] != "random") {
    if (inits[1] == "fixed") {
      inits_fixed <- c(0.25, 0.75, 2.0, 0.2)
    } else {
      if (length(inits) == numPars) {
        inits_fixed <- inits
      } else {
        stop("Check your inital values!")
      }
    }
    genInitList <- function() {
      list(
        d   = inits_fixed[1],
        A   = inits_fixed[2],
        v   = inits_fixed[3],
        tau = inits_fixed[4]
)
    }
  } else {
    genInitList <- "random"
  }

  if (ncore > 1) {
    numCores <- parallel::detectCores()
    if (numCores < ncore) {
      options(mc.cores = numCores)
      warning('Number of cores specified for parallel computing greater than number of locally available cores. Using all locally available cores.')
    }
    else{
      options(mc.cores = ncore)
    }
  }
  else {
    options(mc.cores = 1)
  }

  cat("***********************************\n")
  cat("**  Loading a precompiled model  **\n")
  cat("***********************************\n")

  # Fit the Stan model
  if (FLAG_BUILD_ALL) {
    m = stanmodels$choiceRT_lba_single
  } else {
    model_path <- system.file("stan_files", paste0(modelName, ".stan"),
                              package="hBayesDM")
    m <- rstan::stan_model(model_path)
  }

  if (vb) {   # if variational Bayesian
    fit = rstan::vb(m,
                    data   = dataList,
                    pars   = POI,
                    init   = genInitList)
  } else {
    fit = rstan::sampling(m,
                          data   = dataList,
                          pars   = POI,
                          warmup = nwarmup,
                          init   = genInitList,
                          iter   = niter,
                          chains = nchain,
                          thin   = nthin,
                          control = list(adapt_delta   = adapt_delta,
                                         max_treedepth = max_treedepth,
                                         stepsize      = stepsize))
  }
  parVals <- rstan::extract(fit, permuted = T)
  if (inc_postpred) {
    parVals$y_pred[parVals$y_pred == -1] <- NA
  }

  d   <- parVals$d
  A   <- parVals$A
  v   <- parVals$v
  tau <- parVals$tau

  if (indPars == "mean") {
    allIndPars <- c(mean(d),
                     mean(A),
                     as.vector(apply(v, c(2,3), mean)),
                     mean(tau))
  } else if (indPars == "median") {
    allIndPars <- c(median(d),
                     median(A),
                     as.vector(apply(v, c(2,3), median)),
                     median(tau))
  } else if (indPars == "mode") {
    allIndPars <- c(estimate_mode(d),
                     estimate_mode(A),
                     as.vector(apply(v, c(2,3), estimate_mode)),
                     estimate_mode(tau))
  }

  allIndPars           <- t(as.data.frame(allIndPars))
  allIndPars           <- as.data.frame(allIndPars)
  allIndPars$subjID    <- subjID
  colnames(allIndPars) <- c("d",
                            "A",
                            apply(expand.grid(paste0("v_cd", 1:N_cond),
                                              paste0("_ch", 1:N_choice)),
                                  1, paste, collapse = ""),
                            "tau",
                            "subjID")


  # Wrap up data into a list
  modelData        <- list(modelName, allIndPars, parVals, fit, rawdata)
  names(modelData) <- c("model", "allIndPars", "parVals", "fit", "rawdata")
  class(modelData) <- "hBayesDM"

  # Total time of computations
  endTime  <- Sys.time()
  timeTook <- endTime - startTime

  # If saveDir is specified, save modelData as a file. If not, don't save
  # Save each file with its model name and time stamp (date & time (hr & min))
  if (!is.null(saveDir)) {
    currTime  <- Sys.time()
    currDate  <- Sys.Date()
    currHr    <- substr(currTime, 12, 13)
    currMin   <- substr(currTime, 15, 16)
    timeStamp <- paste0(currDate, "_", currHr, "_", currMin)
    dataFileName = sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(data))
    save(modelData, file = file.path(saveDir, paste0(modelName, "_", dataFileName, "_", timeStamp, ".RData")))
  }

  # Inform user of completion
  cat("\n************************************\n")
  cat("**** Model fitting is complete! ****\n")
  cat("************************************\n")

  return(modelData)
}

