#' @param model_name The name of the model.
#' @param model_code Filename for the corresponding stan file.
#' e.g., ra_prospect.stan
#' @param datapath_example Path
#' @param
#' @param
#' @param
#' @param func_preprocess A function to preprocess the raw data.
#' It should take one argument, \\code{rawdata}.
#' It should return a list object with 4 keys: ID, N, T, Tsubj.

model_base <- function(model_name,
                       model_code,
                       datapath_example,
                       model_params,
                       available_model_regressor,
                       model_regressors,
                       func_preprocess,
                       ) {
  ret <- function(data           = "choose",
                  niter          = 4000,
                  nwarmup        = 1000,
                  nchain         = 4,
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

    # model regressors (for model-based neuroimaging, etc.)
    if (modelRegressor) {
      if (available_model_regressor) {
        cat("************************************\n")
        cat("** Extract model-based regressors **\n")
        cat("************************************\n")
      } else {
        stop("** Model-based regressors are not available for this model **\n")
      }
    }

    # To see how long computations take
    startTime <- Sys.time()

    # For using example data
    if (data == "example") {
      data <- system.file("extdata", datapath_example, package = "hBayesDM")
    } else if (data == "choose") {
      data <- file.choose()
    }

    # Load data
    if (file.exists(data)) {
      rawdata <- read.table(data, header = TRUE, sep = "\t")
    } else {
      stop("** The data file does not exist. Please check it again. **\n  e.g., data = '/MyFolder/SubFolder/dataFile.txt', ... **\n")
    }

    # Remove rows containing NAs
    NA_rows_all = which(is.na(rawdata), arr.ind = TRUE)  # rows with NAs
    NA_rows = unique(NA_rows_all[, "row"])
    if (length(NA_rows) > 0) {
      rawdata = rawdata[-NA_rows,]
      cat("The number of rows with NAs = ", length(NA_rows), ". They are removed prior to modeling the data. \n", sep = "")
    }

    # Specify the number of parameters and parameters of interest
    # model_params <- c("rho", "lambda", "tau")
    numPars <- lenght(model_params)

    POI <- c("log_lik")
    POI <- c(POI, mapply(function(x) paste0("mu_", x), model_params))
    POI <- c(POI, "sigma")
    POI <- c(POI, model_params)

    if (modelRegressor) {
      POI <- c(POI, model_regressors)
    }

    if (inc_postpred) {
      POI <- c(POI, "y_pred")
    }

    modelName <- model_name

    ################################################################################
    # THE DATA.  ###################################################################
    ################################################################################

    dataList <- func_preprocess(rawdata)
    numSubjs <- dataList[['N']]
    subjList <- dataList[['ID']]
    Tsubj <- dataList[['Tsubj']]
    maxTrials <- dataList[['T']]

    # inits
    # TODO: Make another common function to define the initial values.
    if (inits[1] != "random") {
      if (inits[1] == "fixed") {
        inits_fixed <- c(1.0, 1.0, 1.0)
      } else {
        if (length(inits) == numPars) {
          inits_fixed <- inits
        } else {
          stop("Check your inital values!")
        }
      }
      genInitList <- function() {
        list(
          mu_p     = c( qnorm( inits_fixed[1]/2), qnorm( inits_fixed[2]/5), qnorm( inits_fixed[3]/5)),
          sigma    = c(1.0, 1.0, 1.0),
          rho_p    = rep(qnorm( inits_fixed[1]/2), numSubjs),
          lambda_p = rep(qnorm( inits_fixed[2]/5), numSubjs),
          tau_p    = rep(qnorm( inits_fixed[3]/5), numSubjs)
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

    # Information for user
    cat("\n")
    cat("Model name = ", modelName, "\n")
    cat("Data file  = ", data, "\n")
    cat("\n")
    cat("Details:\n")
    if (vb) {
      cat(" # Using variational inference # \n")
    } else {
      cat(" # of chains                   = ", nchain, "\n")
      cat(" # of cores used               = ", ncore, "\n")
      cat(" # of MCMC samples (per chain) = ", niter, "\n")
      cat(" # of burn-in samples          = ", nwarmup, "\n")
    }
    cat(" # of subjects                 = ", numSubjs, "\n")

    # Information for user continued
    cat(" # of (max) trials per subject = ", maxTrials, "\n\n")

    cat("***********************************\n")
    cat("**  Loading a precompiled model  **\n")
    cat("***********************************\n")

    # Fit the Stan model
    if (FLAG_CRAN_VERSION) {
      modelPath <- system.file("stan", model_code, package="hBayesDM")
      m = rstan::stan_model(modelPath)
    } else {
      m = stanmodels[[gsub('.stan', '', model_code)]]
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

    # Extract the Stan fit object
    parVals <- rstan::extract(fit, permuted = TRUE)
    if (inc_postpred) {
      parVals$y_pred[parVals$y_pred == -1] <- NA
    }

    # Individual parameters (e.g., individual posterior means)
    measureIndPars <- switch(indPars, mean=mean, median=median, mode=estimate_mode)
    allIndPars <- array(NA, c(numSubjs, numPars))
    allIndPars <- as.data.frame(allIndPars)

    for (i in 1:numSubjs) {
      allIndPars[i,] <- mapply(function(param) {
        measureIndPars(parVals[[param]][, i])
      }, model_params)
    }

    allIndPars           <- cbind(subjList, allIndPars)
    colnames(allIndPars) <- c("subjID", model_params)

    # Wrap up data into a list
    modelData                 <- list()
    modelData$model           <- modelName
    modelData$allIndPars      <- allIndPars
    modelData$parVals         <- parVals
    modelData$fit             <- fit
    modelData$rawdata         <- rawdata
    modelData$modelRegressor  <- NA

    # # Example code for Model Regressors
    # # Imported from PRL_RL
    # if (modelRegressor) {
    #   ev_c  <- apply(parVals$mr_ev_c, c(2, 3), measureIndPars)
    #   ev_nc <- apply(parVals$mr_ev_nc, c(2, 3), measureIndPars)
    #   pe    <- apply(parVals$mr_pe, c(2, 3), measureIndPars)

    #   # Initialize modelRegressor and add model-based regressors
    #   regressors        <- NULL
    #   regressors$ev_c   <- ev_c
    #   regressors$ev_nc  <- ev_nc
    #   regressors$pe     <- pe

    #   modelData$modelRegressor <- regressors
    # }

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
    cat("\n")
    cat("************************************\n")
    cat("**** Model fitting is complete! ****\n")
    cat("************************************\n")

    return(modelData)
  }

  return (ret)
}

func_preprocess <- function(rawdata) {
  # Individual Subjects
  subjList <- unique(rawdata[,"subjID"]) # list of subjects x blocks
  numSubjs <- length(subjList)           # number of subjects

  Tsubj <- as.vector(rep(0, numSubjs)) # number of trials for each subject

  for (sIdx in 1:numSubjs)  {
    curSubj     <- subjList[ sIdx]
    Tsubj[sIdx] <- sum( rawdata$subjID == curSubj)  # Tsubj[N]
  }

  maxTrials <- max(Tsubj)

  # for multiple subjects
  gain    <- array(0, c(numSubjs, maxTrials))
  loss    <- array(0, c(numSubjs, maxTrials))
  cert    <- array(0, c(numSubjs, maxTrials))
  gamble  <- array(-1, c(numSubjs, maxTrials))

  for (i in 1:numSubjs) {
    curSubj      <- subjList[i]
    useTrials    <- Tsubj[i]
    tmp          <- subset(rawdata, rawdata$subjID == curSubj)
    gain[i, 1:useTrials]    <- tmp[1:useTrials, "gain"]
    loss[i, 1:useTrials]    <- abs(tmp[1:useTrials, "loss"])  # absolute loss amount
    cert[i, 1:useTrials]    <- tmp[1:useTrials, "cert"]
    gamble[i, 1:useTrials]  <- tmp[1:useTrials, "gamble"]
  }

  dataList <- list(
    ID      = subjList,
    N       = numSubjs,
    T       = maxTrials,
    Tsubj   = Tsubj,
    gain    = gain,
    loss    = loss,
    cert    = cert,
    gamble  = gamble)

  return(dataList)
}

