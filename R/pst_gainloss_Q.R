#' Probabilistic Selection Task
#'
#' @description
#' Hierarchical Bayesian Modeling of the Probabilistic Selection Task
#' with the following parameters:
#' "alpha_pos" (Learning rate for positive feedbacks),
#' "alpha_neg" (Learning rate for negative feedbacks), and
#' "beta" (inverse temperature).
#'
#' Contributor: \href{https://ccs-lab.github.io/team/jaeyeong-yang/}{Jaeyeong Yang}
#'
#' \strong{MODEL:}
#' Gain-loss Q learning model (Frank et al., 2007)
#'
#' @param data A .txt file containing the data to be modeled.
#' Data columns should be labelled as follows:
#' "subjID", "type", "choice", and "reward".
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
#' @param vb Use variational inference to approximately draw from a posterior distribution. Defaults to FALSE.
#' @param inc_postpred Include trial-level posterior predictive simulations in model output (may greatly increase file size). Defaults to FALSE.
#' @param adapt_delta Floating point number representing the target acceptance probability of a new sample in the MCMC chain. Must be between 0 and 1. See \bold{Details} below.
#' @param stepsize Integer value specifying the size of each leapfrog step that the MCMC sampler can take on each new iteration. See \bold{Details} below.
#' @param max_treedepth Integer value specifying how many leapfrog steps that the MCMC sampler can take on each new iteration. See \bold{Details} below.
#'
#' @return \code{modelData}  A class \code{"hBayesDM"} object with the following components:
#' \describe{
#'  \item{\code{model}}{Character string with the name of the model (\code{"pst_gainloss_Q"}).}
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
#' represent variables. For the Probabilistic Selection Task, there should be four columns of data with the labels
#' "subjID", "type", "choice", and "reward". It is not necessary for the columns to be in this
#' particular order, however it is necessary that they be labelled correctly and contain the information below:
#' \describe{
#'  \item{\code{"subjID"}}{A unique identifier for each subject within data-set to be analyzed.}
#'  \item{\code{"type"}}{The type of stimuli in the trial. For given 6 stimuli, \code{"type"} should be given
#'    in a form as \code{"option1""option2"}, e.g., \code{12}, \code{34}, \code{56}.
#'
#'    The code for each option should be defined as below:
#'    \tabular{ccl}{
#'      Code \tab Stimulus \tab Probability to win \cr
#'      \code{1} \tab A \tab 80\% \cr
#'      \code{2} \tab B \tab 20\% \cr
#'      \code{3} \tab C \tab 70\% \cr
#'      \code{4} \tab D \tab 30\% \cr
#'      \code{5} \tab E \tab 60\% \cr
#'      \code{6} \tab F \tab 40\%
#'    }
#'    The function will work even if you use different probabilities for stimuli,
#'    but the total number of stimuli should be less than or equal to 6.
#'  }
#'  \item{\code{"choice"}}{Whether a subject choose the left option between given two options.}
#'  \item{\code{"reward"}}{Amount of reward as a result of the choice.}
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
#' Frank, M. J., Moustafa, A. A., Haughey, H. M., Curran, T., & Hutchison, K. E. (2007).
#' Genetic triple dissociation reveals multiple roles for dopamine in reinforcement learning.
#' Proceedings of the National Academy of Sciences, 104(41), 16311-16316.
#'
#' @seealso
#' We refer users to our in-depth tutorial for an example of using hBayesDM: \url{https://rpubs.com/CCSL/hBayesDM}
#'
#' @examples
#' \dontrun{
#' # Run the model and store results in "output"
#' output <- pst_gainloss_Q(data = "example", niter = 2000, nwarmup = 1000, nchain = 4, ncore = 4)
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

pst_gainloss_Q <- function(data           = "choose",
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
    stop("** Model-based regressors are not available for this model **\n")
  }

  # To see how long computations take
  startTime <- Sys.time()

  # For using example data
  if (data == "example") {
    data <- system.file("extdata", "pst_exampleData.txt", package = "hBayesDM")
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
  POI     <- c("mu_alpha_pos", "mu_alpha_neg", "mu_beta",
               "alpha_pos" , "alpha_neg", "beta",
               "log_lik")

  # TODO: Check which indices are needed for regressors
  if (modelRegressor)
    POI <- c(POI)

  if (inc_postpred)
    POI <- c(POI, "y_pred")

  modelName <- "pst_gainloss_Q"

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
  option1 <- array(-1, c(numSubjs, maxTrials))
  option2 <- array(-1, c(numSubjs, maxTrials))
  choice  <- array(-1, c(numSubjs, maxTrials))
  reward  <- array(-1, c(numSubjs, maxTrials))

  for (i in 1:numSubjs) {
    subj      <- subjList[i]
    useTrials <- Tsubj[i]
    tmp       <- subset(rawdata, rawdata$subjID == subj)

    option1[i, 1:useTrials] <- tmp$type %/% 10
    option2[i, 1:useTrials] <- tmp$type %% 10
    choice[i, 1:useTrials] <- tmp$choice
    reward[i, 1:useTrials] <- tmp$reward
  }

  dataList <- list(
    'N'       = numSubjs,
    'T'       = maxTrials,
    'Tsubj'   = Tsubj,
    'option1' = option1,
    'option2' = option2,
    'choice'  = choice,
    'reward'  = reward
  )

  # inits
  if (inits[1] == "random") {
    genInitList <- "random"
  } else {
    if (inits[1] == "fixed") {
      inits_fixed <- c(1.0, 1.0, 1.0)
    } else {
      if (length(inits) == numPars)
        inits_fixed <- inits
      else
        stop("Check your inital values!")
    }

    # TODO: Change expressions of randomly generated values in genInitList
    genInitList <- function() {
      list(
        mu_p    = c(qnorm(inits_fixed[1]), qnorm(inits_fixed[2]), qnorm(inits_fixed[3] / 10)),
        sigma   = c(1.0, 1.0, 1.0),
        alpha_pos_pr = rep(qnorm(inits_fixed[1]), numSubjs),
        alpha_pos_pr = rep(qnorm(inits_fixed[2]), numSubjs),
        beta_pr = rep(qnorm(inits_fixed[3] / 10), numSubjs)
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
  m <- stanmodels$pst_gainloss_Q

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

  alpha_pos <- parVals$alpha_pos
  alpha_neg <- parVals$alpha_neg
  beta      <- parVals$beta

  # Individual parameters (e.g., individual posterior means)
  measureIndPars <- switch(indPars, mean=mean, median=median, mode=estimate_mode)
  allIndPars <- array(NA, c(numSubjs, numPars))
  allIndPars <- as.data.frame(allIndPars)

  # TODO: Use *apply function instead of for loop
  for (i in 1:numSubjs) {
    allIndPars[i, ] <- c(measureIndPars(alpha_pos[, i]),
                         measureIndPars(alpha_neg[, i]),
                         measureIndPars(beta[, i]))
  }

  allIndPars           <- cbind(allIndPars, subjList)
  colnames(allIndPars) <- c("alpha_pos",
                            "alpha_neg",
                            "beta",
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
    # Initialize modelRegressor and add model-based regressors
    modelRegressor        <- NULL
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

