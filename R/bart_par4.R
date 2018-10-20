#' Balloon Analogue Risk Task (Ravenzwaaij et al., 2011, Journal of Mathematical Psychology)
#'
#' @description
#' Hierarchical Bayesian Modeling of the Balloon Analogue Risk Task with the following 4 parameters: "phi" (prior belief of the balloon not going to be burst), "eta" (updating rate), "gam" (risk-taking parameter), and "tau" (inverse temperature).\cr\cr
#'
#' Contributor: \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park}, \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang}, \href{https://ccs-lab.github.io/team/ayoung-lee/}{Ayoung Lee}, \href{https://ccs-lab.github.io/team/jeongbin-oh/}{Jeongbin Oh}, \href{https://ccs-lab.github.io/team/jiyoon-lee/}{Jiyoon Lee}, \href{https://ccs-lab.github.io/team/junha-jang/}{Junha Jang}
#'
#' \strong{MODEL:}
#' Reparameterized version (by Harhim Park & Jaeyeong Yang) of Balloon Analogue Risk Task model (Ravenzwaaij et al., 2011) with four parameters
#'
#' @param data A .txt file containing the data to be modeled. Data columns should be labelled as follows: "subjID", "pumps", and "explosion". See \bold{Details} below for more information.
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
#'  \item{\code{model}}{Character string with the name of the model (\code{"bart_par4"}).}
#'  \item{\code{allIndPars}}{\code{"data.frame"} containing the summarized parameter
#'    values (as specified by \code{"indPars"}) for each subject.}
#'  \item{\code{parVals}}{A \code{"list"} where each element contains posterior samples
#'    over different model parameters. }
#'  \item{\code{fit}}{A class \code{"stanfit"} object containing the fitted model.}
#'  \item{\code{rawdata}}{\code{"data.frame"} containing the raw data used to fit the model, as specified by the user.}
#' }
#'
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
#' represent variables. For the Balloon Analogue Risk Task, there should be three columns of data  with the labels
#' "subjID", "pumps", "explosion". It is not necessary for the columns to be in this
#' particular order, however it is necessary that they be labelled correctly and contain the information below:
#' \describe{
#'  \item{\code{"subjID"}}{A unique identifier for each subject within data-set to be analyzed.}
#'  \item{\code{"pumps"}}{The number of pumps}
#'  \item{\code{"explosion"}}{0: intact, 1: burst}
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
#' @export
#'
#' @references
#' van Ravenzwaaij, D., Dutilh, G., & Wagenmakers, E. J. (2011). Cognitive model decomposition of the BART: Assessment and application.
#' Journal of Mathematical Psychology, 55(1), 94-105.
#'
#' @seealso
#' We refer users to our in-depth tutorial for an example of using hBayesDM: \url{https://rpubs.com/CCSL/hBayesDM}
#'
#' @examples
#' \dontrun{
#' # Run the model and store results in "output"
#' output <- bart_par4(data = "example", niter = 2000, nwarmup = 1000, nchain = 3, ncore = 3)
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
#' }

bart_par4 <- function(data           = "choose",
                            niter          = 4000,
                            nwarmup        = 1000,
                            nchain         = 4,
                            ncore          = 1,
                            nthin          = 1,
                            inits          = "fixed",
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
    data <- system.file("extdata", "bart_exampleData.txt", package = "hBayesDM")
  } else if (data == "choose") {
    data <- file.choose()
  }

  # Load data
  if (file.exists(data)) {
    rawdata <- read.table(data, header = T, sep = "\t")
  } else {
    stop("** The data file does not exist. Please check it again. **\n  e.g., data = '/MyFolder/SubFolder/dataFile.txt', ... **\n")
  }
  # Remove rows containing NAs
  NA_rows_all = which(is.na(rawdata), arr.ind = T)  # rows with NAs
  NA_rows = unique(NA_rows_all[, "row"])
  if (length(NA_rows) > 0) {
    rawdata = rawdata[-NA_rows,]
    cat("The number of rows with NAs = ", length(NA_rows), ". They are removed prior to modeling the data. \n", sep = "")
  }

  # Individual Subjects
  subjList <- unique(rawdata[,"subjID"]) # list of subjects x blocks
  numSubjs <- length(subjList)           # number of subjects

  # Specify the number of parameters and parameters of interest
  numPars <- 4
  POI     <- c("mu_phi", "mu_eta", "mu_gam", "mu_tau",
               "sigma",
               "phi", "eta", "gam", "tau",
               "log_lik")

  if (inc_postpred) {
    POI <- c(POI, "y_pred")
  }

  modelName <- "bart_par4"

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

  Tsubj <- as.vector(rep(0, numSubjs)) # number of trials for each subject

  for (sIdx in 1:numSubjs)  {
    curSubj     <- subjList[sIdx]
    Tsubj[sIdx] <- sum(rawdata$subjID == curSubj)  # Tsubj[N]
  }

  maxTrials <- max(Tsubj)

  # Information for user continued
  cat(" # of (max) trials per subject = ", maxTrials, "\n\n")

  # for multiple subjects
  pumps     <- array(0, c(numSubjs, maxTrials))
  explosion <- array(0, c(numSubjs, maxTrials))

  for (i in 1:numSubjs) {
    curSubj   <- subjList[i]
    useTrials <- Tsubj[i]
    tmp       <- subset(rawdata, rawdata$subjID == curSubj)

    pumps[i, 1:useTrials]     <- tmp[1:useTrials, "pumps"]
    explosion[i, 1:useTrials] <- tmp[1:useTrials, "explosion"]
  }

  maxPumps <- max(pumps)

  dataList <- list(
    N         = numSubjs,
    T         = maxTrials,
    P         = maxPumps + 1,
    Tsubj     = Tsubj,
    numPars   = numPars,
    pumps     = pumps,
    explosion = explosion
  )

  # inits
  if (inits[1] != "random") {
    if (inits[1] == "fixed") {
      inits_fixed <- c(0.5, 1.0, 1.0, 1.0)
    } else {
      if (length(inits) == numPars) {
        inits_fixed <- inits
      } else {
        stop("Check your inital values!")
      }
    }
    genInitList <- function() {
      list(
        mu_p  = c(qnorm(inits_fixed[1]), log(inits_fixed[2:4])),
        sigma = c(1.0, 1.0, 1.0, 1.0),
        phi_p = rep(qnorm(inits_fixed[1]), numSubjs),
        eta_p = rep(log(inits_fixed[2]), numSubjs),
        gam_p = rep(log(inits_fixed[3]), numSubjs),
        tau_p = rep(log(inits_fixed[4]), numSubjs)
      )
    }
  } else {
    genInitList <- "random"
  }

  if (ncore > 1) {
    numCores <- parallel::detectCores()
    if (numCores < ncore) {
      options(mc.cores = numCores)
      warning("Number of cores specified for parallel computing greater than number of locally available cores. Using all locally available cores.")
    } else {
      options(mc.cores = ncore)
    }
  } else {
    options(mc.cores = 1)
  }

  cat("***********************************\n")
  cat("**  Loading a precompiled model  **\n")
  cat("***********************************\n")

  # Fit the Stan model
  m = stanmodels$bart_par4
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
  # Extract the Stan fit object
  parVals <- rstan::extract(fit, permuted = T)
  if (inc_postpred) {
    parVals$y_pred[parVals$y_pred == -1] <- NA
  }

  phi <- parVals$phi
  eta <- parVals$eta
  gam <- parVals$gam
  tau <- parVals$tau

  # Individual parameters (e.g., individual posterior means)
  measureIndPars <- switch(indPars, mean=mean, median=median, mode=estimate_mode)
  allIndPars <- array(NA, c(numSubjs, numPars))
  allIndPars <- as.data.frame(allIndPars)

  for (i in 1:numSubjs) {
    allIndPars[i,] <- c(measureIndPars(phi[, i]),
                        measureIndPars(eta[, i]),
                        measureIndPars(gam[, i]),
                        measureIndPars(tau[, i]))
  }

  allIndPars           <- cbind(allIndPars, subjList)
  colnames(allIndPars) <- c("phi",
                            "eta",
                            "gam",
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
