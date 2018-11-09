#' Choice under Risk and Ambiguity Task
#'
#' @description
#' Hierarchical Bayesian Modeling of the Choice under Risk and Ambiguity Task
#' with the following parameters:
#' "alpha" (risk attitude),
#' "beta" (ambiguity attitude), and
#' "gamma" (inverse temperature).
#'
#' Contributor: \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang}
#'
#' \strong{MODEL:}
#' Exponential subjective value model (Hsu et al., 2005, Science)
#'
#' @param data A .txt file containing the data to be modeled. Data columns should be labelled as follows:
#' "subjID", "prob", "ambig", "reward_var", "reward_fix", and "choice".
#' See \bold{Details} below for more information.
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
#'  \item{\code{model}}{Character string with the name of the model (\code{"cra_exp"}).}
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
#' represent variables. For the Choice under Risk and Ambiguity Task, there should be five columns of data with the labels
#' "subjID", "prob", "ambig", "reward_var", "reward_fix" and "choice". It is not necessary for the columns to be in this
#' particular order, however it is necessary that they be labelled correctly and contain the information below:
#' \describe{
#'  \item{\code{"subjID"}}{A unique identifier for each subject within data-set to be analyzed.}
#'  \item{\code{"prob"}}{Objective probability of a variable lottery.}
#'  \item{\code{"ambig"}}{Ambiguity levels of variable lotteries. For a risky lottery, \code{"ambig"} equals 0, and more than zero for an ambiguous lottery}
#'  \item{\code{"reward_var"}}{Amounts of reward values in variable lotteries. \code{"reward_var"} is assumed to be greater than zero.}
#'  \item{\code{"reward_fix"}}{Amounts of reward values in fixed lotteries. \code{"reward_fix"} is assumed to be greater than zero.}
#'  \item{\code{"choice"}}{If the variable lottery was taken, \code{"choice"} equals 1, otherwise 0.}
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
#' Hsu, M., Bhatt, M., Adolphs, R., Tranel, D., & Camerer, C. F. (2005).
#' Neural systems responding to degrees of uncertainty in human decision-making.
#' Science, 310(5754), 1680-1683. https://doi.org/10.1126/science.1115327
#'
#' @seealso
#' We refer users to our in-depth tutorial for an example of using hBayesDM: \url{https://rpubs.com/CCSL/hBayesDM}
#'
#' @examples
#' \dontrun{
#' # Run the model and store results in "output"
#' output <- cra_exp(data = "example", niter = 2000, nwarmup = 1000, nchain = 4, ncore = 4)
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

cra_exp <- function(data           = "choose",
                    niter          = 2000,
                    nwarmup        = 1000,
                    nchain         = 1,
                    ncore          = 1,
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
    cat("************************************\n")
    cat("** Extract model-based regressors **\n")
    cat("************************************\n")
  }

  # To see how long computations take
  startTime <- Sys.time()

  # For using example data
  if (data == "example") {
    data <- system.file("extdata", "cra_exampleData.txt", package = "hBayesDM")
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
  subjList <- unique(rawdata[, "subjID"]) # list of subjects x blocks
  numSubjs <- length(subjList)           # number of subjects

  # Specify the number of parameters and parameters of interest
  numPars <- 3
  POI     <- c("mu_alpha", "mu_beta", "mu_gamma",
               "alpha" , "beta", "gamma",
               "log_lik")

  # TODO: Check which indices are needed for regressors
  if (modelRegressor)
    POI <- c(POI, "mr_sv", "mr_p_var")

  if (inc_postpred)
    POI <- c(POI, "y_pred")

  modelName <- "cra_linear"

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
  choice <- array(0, c(numSubjs, maxTrials))
  prob   <- array(0, c(numSubjs, maxTrials))
  ambig  <- array(0, c(numSubjs, maxTrials))
  reward_var <- array(0, c(numSubjs, maxTrials))
  reward_fix <- array(0, c(numSubjs, maxTrials))

  for (i in 1:numSubjs) {
    curSubj      <- subjList[i]
    useTrials    <- Tsubj[i]
    tmp          <- subset(rawdata, rawdata$subjID == curSubj)

    choice[i, 1:useTrials]     <- tmp[1:useTrials, "choice"]
    prob[i, 1:useTrials]       <- tmp[1:useTrials, "prob"]
    ambig[i, 1:useTrials]      <- tmp[1:useTrials, "ambig"]
    reward_var[i, 1:useTrials] <- tmp[1:useTrials, "reward_var"]
    reward_fix[i, 1:useTrials] <- tmp[1:useTrials, "reward_fix"]
  }

  dataList <- list(
    N       = numSubjs,
    T       = maxTrials,
    Tsubj   = Tsubj,
    choice  = choice,
    prob    = prob,
    ambig   = ambig,
    reward_var = reward_var,
    reward_fix = reward_fix)

  # inits
  if (inits[1] == "random") {
    genInitList <- "random"
  } else {
    if (inits[1] == "fixed") {
      inits_fixed <- c(1.0, 0.0, 1.0)
    } else {
      if (length(inits) == numPars)
        inits_fixed <- inits
      else
        stop("Check your inital values!")
    }

    # TODO: Change expressions of randomly generated values in genInitList
    genInitList <- function() {
      list(
        mu_p    = c(qnorm(inits_fixed[1] / 2), inits_fixed[2], qnorm(inits_fixed[3])),
        sigma   = c(1.0, 1.0, 1.0),
        alpha_p = rep(qnorm(inits_fixed[1] / 2), numSubjs),
        beta_p  = rep(inits_fixed[2], numSubjs),
        gamma_p = rep(qnorm(inits_fixed[3]), numSubjs)
      )
    }
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
  m <- stanmodels$cra_exp

  if (vb) {   # if variational Bayesian
    fit <- rstan::vb(m,
                     data   = dataList,
                     pars   = POI,
                     init   = genInitList)
  } else {
    fit <- rstan::sampling(m,
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
  if (inc_postpred)
    parVals$y_pred[parVals$y_pred == -1] <- NA

  alpha  <- parVals$alpha
  beta   <- parVals$beta
  gamma  <- parVals$gamma

  # Individual parameters (e.g., individual posterior means)
  measureIndPars <- switch(indPars, mean=mean, median=median, mode=estimate_mode)
  allIndPars <- array(NA, c(numSubjs, numPars))
  allIndPars <- as.data.frame(allIndPars)

  # TODO: Use *apply function instead of for loop
  for (i in 1:numSubjs) {
    allIndPars[i, ] <- c(measureIndPars(alpha[, i]),
                         measureIndPars(beta[, i]),
                         measureIndPars(gamma[, i]))
  }

  allIndPars           <- cbind(allIndPars, subjList)
  colnames(allIndPars) <- c("alpha",
                            "beta",
                            "gamma",
                            "subjID")

  # Wrap up data into a list
  modelData                 <- list()
  modelData$model           <- modelName
  modelData$allIndPars      <- allIndPars
  modelData$parVals         <- parVals
  modelData$fit             <- fit
  modelData$rawdata         <- rawdata
  modelData$modelRegressor  <- NA

  # TODO: Change this block after re-choosing the proper regressors
  if (modelRegressor) {
    sv    <- apply(parVals$mr_sv,     c(2, 3), measureIndPars)
    p_var <- apply(parVals$mr_p_var,  c(2, 3), measureIndPars)

    # Initialize modelRegressor and add model-based regressors
    modelRegressor        <- NULL
    modelRegressor$sv     <- sv
    modelRegressor$p_var  <- p_var

    modelData$modelRegressor <- modelRegressor
  }

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

