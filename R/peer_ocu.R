#' Peer influence task (Chung et al., 2015 Nature Neuroscience)
#'
#' @description
#' Hierarchical Bayesian Modeling of the Peer Influence Task with the following parameters: "rho" (risk preference), "tau" (inverse temperature), and "ocu" (other-conferred utility).\cr\cr
#'
#' Contributor: \href{https://ccs-lab.github.io/team/harhim-park/}{Harhim Park}
#'
#' \strong{MODEL:}
#' Peer influence task - OCU (other-conferred utility) model
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
#'  \item{\code{model}}{Character string with the name of the model (\code{"ra_prospect"}).}
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
#' represent variables. For the Risk Aversion Task, there should be four columns of data  with the labels
#' "subjID", "condition", "p_gamble", "safe_Hpayoff", "safe_Lpayoff", "risky_Hpayoff", "risky_Lpayoff", "choice". It is not necessary for the columns to be in this
#' particular order, however it is necessary that they be labelled correctly and contain the information below:
#' \describe{
#'  \item{\code{"subjID"}}{A unique identifier for each subject within data-set to be analyzed.}
#'  \item{\code{"condition"}}{0: solo, 1: info (safe/safe), 2: info (mix), 3: info (risky/risky)}
#'  \item{\code{"p_gamble"}}{Probability of receiving a high payoff (same for both options)}
#'  \item{\code{"safe_Hpayoff"}}{High payoff of the safe option}
#'  \item{\code{"safe_Lpayoff"}}{Low payoff of the safe option}
#'  \item{\code{"risky_Hpayoff"}}{High payoff of the risky option}
#'  \item{\code{"risky_Lpayoff"}}{Low payoff of the risky option}
#'  \item{\code{"choice"}}{Which option was chosen? 0: safe 1: risky}
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
#' Chung, D., Christopoulos, G. I., King-Casas, B., Ball, S. B., & Chiu, P. H. (2015). Social signals of safety and risk confer utility and have asymmetric effects on observers' choices.
#' Nature neuroscience, 18(6), 912-916.
#'
#' @seealso
#' We refer users to our in-depth tutorial for an example of using hBayesDM: \url{https://rpubs.com/CCSL/hBayesDM}
#'
#' @examples
#' \dontrun{
#' # Run the model and store results in "output"
#' output <- peer_ocu(data = "example", niter = 2000, nwarmup = 1000, nchain = 3, ncore = 3)
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

peer_ocu <- function(data           = "choose",
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
    data <- system.file("extdata", "peer_exampleData.txt", package = "hBayesDM")
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
  numPars <- 3
  POI     <- c("mu_rho", "mu_tau", "mu_ocu",
               "sigma",
               "rho" , "tau", "ocu",
               "log_lik")

  if (inc_postpred) {
    POI <- c(POI, "y_pred")
  }

  modelName <- "peer_ocu"

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
  safe_Hpayoff    <- array(0, c(numSubjs, maxTrials))
  safe_Lpayoff    <- array(0, c(numSubjs, maxTrials))
  risky_Hpayoff    <- array(0, c(numSubjs, maxTrials))
  risky_Lpayoff    <- array(0, c(numSubjs, maxTrials))
  condition    <- array(0, c(numSubjs, maxTrials))
  p_gamble    <- array(0, c(numSubjs, maxTrials))
  choice  <- array(-1, c(numSubjs, maxTrials))

  for (i in 1:numSubjs) {
    curSubj      <- subjList[i]
    useTrials    <- Tsubj[i]
    tmp          <- subset(rawdata, rawdata$subjID == curSubj)
    safe_Hpayoff[i, 1:useTrials]    <- tmp[1:useTrials, "safe_Hpayoff"]
    safe_Lpayoff[i, 1:useTrials]    <- tmp[1:useTrials, "safe_Lpayoff"]
    risky_Hpayoff[i, 1:useTrials]    <- tmp[1:useTrials, "risky_Hpayoff"]
    risky_Lpayoff[i, 1:useTrials]    <- tmp[1:useTrials, "risky_Lpayoff"]
    condition[i, 1:useTrials]    <- tmp[1:useTrials, "condition"]
    p_gamble[i, 1:useTrials]    <- tmp[1:useTrials, "p_gamble"]
    choice[i, 1:useTrials]    <- tmp[1:useTrials, "choice"]
  }

  dataList <- list(
    N       = numSubjs,
    T       = maxTrials,
    Tsubj   = Tsubj,
    numPars = numPars,
    safe_Hpayoff    = safe_Hpayoff,
    safe_Lpayoff    = safe_Lpayoff,
    risky_Hpayoff    = risky_Hpayoff,
    risky_Lpayoff    = risky_Lpayoff,
    condition  = condition,
    p_gamble = p_gamble,
    choice = choice
)

  # inits
  if (inits[1] != "random") {
    if (inits[1] == "fixed") {
      inits_fixed <- c(1.0, 1.0, 0.0)
    } else {
      if (length(inits) == numPars) {
        inits_fixed <- inits
      } else {
        stop("Check your inital values!")
      }
    }
    genInitList <- function() {
      list(
        mu_p     = c(qnorm(inits_fixed[1]/2), log(inits_fixed[2]), inits_fixed[3]),
        sigma    = c(1.0, 1.0, 1.0),
        rho_p    = rep(qnorm(inits_fixed[1]/2), numSubjs),
        tau_p    = rep(log(inits_fixed[2]), numSubjs,
        ocu_p    = rep(inits_fixed[3]), numSubjs)
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
  m = stanmodels$peer_ocu
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

  rho    <- parVals$rho
  tau    <- parVals$tau
  ocu    <- parVals$ocu

  # Individual parameters (e.g., individual posterior means)
  allIndPars <- array(NA, c(numSubjs, numPars))
  allIndPars <- as.data.frame(allIndPars)

  for (i in 1:numSubjs) {
    if (indPars == "mean") {
      allIndPars[i,] <- c(mean(rho[, i]),
                            mean(tau[, i]),
                            mean(ocu[, i]))
    } else if (indPars == "median") {
      allIndPars[i,] <- c(median(rho[, i]),
                            median(tau[, i]),
                            median(ocu[, i]))
    } else if (indPars == "mode") {
      allIndPars[i,] <- c(estimate_mode(rho[, i]),
                            estimate_mode(tau[, i]),
                            estimate_mode(ocu[, i]))
    }
  }

  allIndPars           <- cbind(allIndPars, subjList)
  colnames(allIndPars) <- c("rho",
                            "tau",
                            "ocu",
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
