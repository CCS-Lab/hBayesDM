#' @param task_name Name of the task, e.g. \code{"gng"}.
#' @param model_name Name of the model, e.g. \code{"m1"}.
#' @param model_type One of the following three: \code{NULL} OR \code{"single"} OR \code{"multipleB"}.
#' @param data_columns Names of the necessary columns for the data, e.g. \code{c("subjID", "cue", "keyPressed", "outcome")}. Must be the entirety of necessary data columns that will be used at some point in the code, i.e. must always include \code{"subjID"}, and should include \code{"block"} in the case of 'multipleB' type models.
#' @param parameters Names of the parameters of this model, e.g. \code{c("xi", "ep", "rho")}.
#' @param regressors Names of the model-based regressors, e.g. \code{c("Qgo", "Qnogo", "Wgo", "Wnogo")}, OR if model-based regressors are not available for this model, \code{NULL}.
#' @param preprocess_function The model-specific function to preprocess the raw data to pass to Stan.

# TODO: Specify argument and return info for the @param preprocess_function.
# TODO: nrow/dim/length

model_base <- function(task_name,
                       model_name,
                       model_type = NULL,
                       data_columns,
                       parameters,
                       regressors = NULL,
                       preprocess_function) {

  # The resulting hBayesDM model function to be returned
  function(data           = "choose",
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

    ############### Stop checks ###############

    # Check if regressor available for this model
    if (modelRegressor && is.null(regressors)) {
      stop("** Model-based regressors are not available for this model. **\n")
    }

    # For using "example" or "choose" data
    if (data == "example") {
      example_filename <- paste0(c(task_name, model_type, "exampleData.txt"), collapse = "_")
      data <- system.file("extdata", example_filename, package = "hBayesDM")
    } else if (data == "choose") {
      data <- file.choose()
    }

    # Load the data
    if (file.exists(data)) {
      raw_data <- read.table(data, header = TRUE, sep = "\t")
    } else {
      stop("** Data file does not exist. Please check again. **\n",
           "  e.g. data = \"MySubFolder/myData.txt\"\n")
    }

    # Check if necessary data columns all exist (while ignoring case and underscores)
    data_columns       <- tolower(gsub("_", "", data_columns, fixed = TRUE))
    colnames(raw_data) <- tolower(gsub("_", "", colnames(raw_data), fixed = TRUE))
    if (!all(data_columns %in% colnames(raw_data))) {
      stop("** Data file is missing one or more necessary data columns. Please check again. **\n",
           "  Necessary data columns are: \"", paste0(data_columns, collapse = "\", \""), "\".\n")
    }
    # NOTE: One difference in code caused by allowing case & underscore insensitive
    # column names in user data is that `raw_data` column names must here on forth
    # always be referenced by their lowercase non-underscored version, e.g. "subjid".

    # Remove only the rows containing NAs in necessary columns
    complete_rows         <- complete.cases(raw_data[, data_columns])
    incomplete_rows_count <- sum(!complete_rows)
    if (incomplete_rows_count > 0) {
      raw_data <- raw_data[complete_rows, ]
      cat("\n")
      cat("The following lines of the data file have NAs in necessary columns:\n")
      cat(paste0(head(which(!complete_rows), 100) + 1, collapse = ", "))
      if (incomplete_rows_count > 100) {
        cat(", ...")
      }
      cat(" (total", incomplete_rows_count, "lines)\n")
      cat("These rows are removed prior to modeling the data.\n")
    }

    ####################################################
    ##   Prepare general info about the raw data   #####
    ####################################################

    subjects         <- NULL  # List of unique subjects (1D)
    subjects_count   <- NULL  # Total number of subjects (0D)

    blocks           <- NULL  # List of the different blocks per each subject (2D)
    blocks_count     <- NULL  # Number of blocks per each subject (1D)
    blocks_count_max <- NULL  # Maximum number of blocks across all subjects (0D)

    trials_count     <- NULL  # Number of trials (per block) per subject (2D or 1D)
    trials_count_max <- NULL  # Maximum number of trials across all blocks & subjects (0D)

    # NOTE: Code is currently considering the possibility that subjects may have different
    # naming schemes for their blocks. If willing to enforce a rule that in the data,
    # block names must be unified across all subjects, e.g. "all block names start at 1 and
    # count upwards", a simpler and more efficient code will be possible. For instance,
    # `blocks_count_max <- length(unique(raw_data$block))` would be sufficient.

    # TODO: Completion to here.
    # TODO: Resume from here:

#    if(model_type != "multipleB"){
#    }

#    subjects <- unique(raw_data$subjid)
#    subjects_count <- length(subjects)

#    if (model_type == "single" && subjects_count != 1) {
#      stop("** More than 1 unique subjects exist in data file, while using 'single' type model. **\n")
#    }

#    if (model_type == "multipleB") {
#      tmp <- NULL
#      for (sIdx in 1:subjects_count) {
#        tmp <- rle(sort(raw_data[raw_data$subjID == subjects[sIdx], ]$block))
#        blocks_count_max <-
#        blocks[tmp$values]

#        blocks_count[sIdx] <- sum(rows_curr_subject$

#    blocks <- array(
#    num_blocks <- vector("integer", num_subjects)    # list of number of blocks for each subject
#    max_num_blocks <- NA                             # maximum number of blocks for any subject

#    if (model_type == "multipleB") {
#      for (sIdx in 1:num_subjects) {
#        curr_subject <- subjects[sIdx]
#        rows_curr_subject <- subset(raw_data, subjID == curr_subject)
#        block
#        Bsubj[sIdx] <- sum(rowsCurrSubj$block == subjList[sIdx])
#      }
#      maxBlocks <- max(Bsubj)
#    }

#    Tsubj
      # number of trials for each subject (or for each subject's each block if model_type == multipleB)
#    maxTrials

#    Tsubj <- as.vector(rep(0, numSubjs)) # number of trials for each subject

#    for (sIdx in 1:numSubjs)  {
#      curSubj     <- subjList[sIdx]
#      Tsubj[sIdx] <- sum(raw_data$subjID == curSubj)  # Tsubj[N]
#    }

#    maxTrials <- max(Tsubj)

    #########################################################
    ##   Prepare: stan_data                             #####
    ##            stan_pars                             #####
    ##            stan_init       for passing to Stan   #####
    #########################################################

    # Preprocess the raw data to make suitable for passing to Stan
    stan_data <- preprocess_function(raw_data)

    # Names of the parameters of interest for Stan
    stan_pars <- c("log_lik")
    # TODO: paste0("mu_", parameter_names) will do the trick
    stan_pars <- c(stan_pars, mapply(function(x) paste0("mu_", x), parameter_names))
    stan_pars <- c(stan_pars, "sigma")
    stan_pars <- c(stan_pars, parameter_names)

    if (modelRegressor) {
      stan_pars <- c(stan_pars, regressor_names)
    }

    if (inc_postpred) {
      stan_pars <- c(stan_pars, "y_pred")
    }

    # inits
    # TODO: Make another common function to define the initial values.
    if (inits[1] != "random") {
      if (inits[1] == "fixed") {
        inits_fixed <- c(1.0, 1.0, 1.0)
      } else {
        if (length(inits) == length(parameter_names)) {
          inits_fixed <- inits
        } else {
          stop("** Check your initial values! **\n")
        }
      }
      stan_init <- function() {
        list(
          mu_p     = c( qnorm( inits_fixed[1]/2), qnorm( inits_fixed[2]/5), qnorm( inits_fixed[3]/5)),
          sigma    = c(1.0, 1.0, 1.0),
          rho_p    = rep(qnorm( inits_fixed[1]/2), numSubjs),
          lambda_p = rep(qnorm( inits_fixed[2]/5), numSubjs),
          tau_p    = rep(qnorm( inits_fixed[3]/5), numSubjs)
        )
      }
    } else {
      stan_init <- "random"
    }


    # Set number of cores for parallel computing
    if (ncore <= 1) {
      ncore <- 1
    } else {
      local_cores <- parallel::detectCores()
      if (ncore > local_cores) {
        ncore <- local_cores
        warning("Number of cores specified for parallel computing greater than number of locally available cores. Using all locally available cores.\n")
      }
    }
    options(mc.cores = ncore)

    # Information for user
    cat("\n")
    cat("Model name  =  ", model_name, "\n", sep = "")
    cat("Data file   =  ", data, "\n", sep = "")
    cat("\n")
    cat("Details:\n")
    if (vb) {
      cat(" Using variational inference\n")
    } else {
      cat(" # of chains                    =  ", nchain, "\n", sep = "")
      cat(" # of cores used                =  ", ncore, "\n", sep = "")
      cat(" # of MCMC samples (per chain)  =  ", niter, "\n", sep = "")
      cat(" # of burn-in samples           =  ", nwarmup, "\n", sep = "")
    }
    cat(" # of subjects                  =  ", numSubjs, "\n", sep = "")
    if (model_type == "multipleB") {
      cat(" # of (max) blocks per subject  =  ", maxBlocks, "\n", sep = "")
    }
    cat(" # of (max) trials per subject  =  ", maxTrials, "\n", sep = "")

    # Path to .stan file
    model_code <- paste0(model_name, ".stan")
    if (FLAG_CRAN_VERSION) {
      modelPath <- system.file("stan", model_code, package = "hBayesDM")
      stan_model <- rstan::stan_model(modelPath)
    } else {
      stan_model <- stanmodels$model_name
      cat("\n")
      cat("***********************************\n")
      cat("**  Loading a precompiled model  **\n")
      cat("***********************************\n")
    }

    # Fit the Stan model
    if (vb) {   # if variational Bayesian
      fit <- rstan::vb(object = stan_model,
                       data   = stan_data,
                       pars   = stan_pars,
                       init   = stan_init)
    } else {
      fit <- rstan::sampling(object  = stan_model,
                             data    = stan_data,
                             pars    = stan_pars,
                             init    = stan_init,
                             chains  = nchain,
                             iter    = niter,
                             warmup  = nwarmup,
                             thin    = nthin,
                             control = list(adapt_delta   = adapt_delta,
                                            stepsize      = stepsize,
                                            max_treedepth = max_treedepth))
    }

    # Extract from the Stan fit object
    parVals <- rstan::extract(fit, permuted = TRUE)
    if (inc_postpred) {
      parVals$y_pred[parVals$y_pred == -1] <- NA
    }

    # Individual parameters (e.g., individual posterior means)
    measureIndPars <- switch(indPars, mean = mean, median = median, mode = estimate_mode) # TODO: Change to even simpler
    allIndPars <- array(NA, c(numSubjs, length(parameter_names)))
    allIndPars <- as.data.frame(allIndPars)

    for (i in 1:numSubjs) {
      allIndPars[i,] <- mapply(function(param) {
        measureIndPars(parVals[[param]][, i])
      }, parameter_names)
    }

    allIndPars           <- cbind(subjList, allIndPars)
    colnames(allIndPars) <- c("subjID", parameter_names)

    # Wrap up data into a list
    modelData                 <- list()
    modelData$model           <- model_name
    modelData$allIndPars      <- allIndPars
    modelData$parVals         <- parVals
    modelData$fit             <- fit
    modelData$rawdata         <- raw_data
    modelData$modelRegressor  <- NA

    # Model regressors (for model-based neuroimaging, etc.)
    if (modelRegressor) {
      cat("\n")
      cat("*****************************************\n")
      cat("**  Extracting model-based regressors  **\n")
      cat("*****************************************\n")

      ev_c  <- apply(parVals$mr_ev_c, c(2, 3), measureIndPars)
      ev_nc <- apply(parVals$mr_ev_nc, c(2, 3), measureIndPars)
      pe    <- apply(parVals$mr_pe, c(2, 3), measureIndPars)

      # Initialize modelRegressor and add model-based regressors
      regressors        <- NULL
      regressors$ev_c   <- ev_c
      regressors$ev_nc  <- ev_nc
      regressors$pe     <- pe

      modelData$modelRegressor <- regressors
    }

    class(modelData) <- "hBayesDM"

    # If saveDir is specified, save modelData as a file. If not, don't save.
    if (!is.null(saveDir)) {
      currDate  <- Sys.Date()
      currTime  <- Sys.time()
      currHr    <- substr(currTime, 12, 13)
      currMin   <- substr(currTime, 15, 16)
      timeStamp <- paste0(currDate, "_", currHr, "_", currMin)
      # TODO: sub("\\..*$", "", basename(str)) # TODO: sub? or gsub?
      dataFileName <- sub(pattern = "(.*)\\..*$", replacement = "\\1", basename(data))
      # Save file with its model name, data info, and time stamp (date & time (hr & min))
      save(modelData, file = file.path(saveDir, paste0(model_name, "_", dataFileName, "_", timeStamp, ".RData")))
    }

    # Inform user of completion
    cat("\n")
    cat("************************************\n")
    cat("**** Model fitting is complete! ****\n")
    cat("************************************\n")

    return(modelData)
  }
}

# rename:
p_f <- function(raw_data) {
  # for multiple subjects
  gain    <- array(0, c(numSubjs, maxTrials))
  loss    <- array(0, c(numSubjs, maxTrials))
  cert    <- array(0, c(numSubjs, maxTrials))
  gamble  <- array(-1, c(numSubjs, maxTrials))

  for (i in 1:numSubjs) {
    curSubj      <- subjList[i]
    useTrials    <- Tsubj[i]
    tmp          <- subset(raw_data, raw_data$subjID == curSubj)
    gain[i, 1:useTrials]    <- tmp[1:useTrials, "gain"]
    loss[i, 1:useTrials]    <- abs(tmp[1:useTrials, "loss"])  # absolute loss amount
    cert[i, 1:useTrials]    <- tmp[1:useTrials, "cert"]
    gamble[i, 1:useTrials]  <- tmp[1:useTrials, "gamble"]
  }

  # TODO: re-check for all necessary data_names?

  stan_data <- list(
    N       = numSubjs,
    T       = maxTrials,
    Tsubj   = Tsubj,
    gain    = gain,
    loss    = loss,
    cert    = cert,
    gamble  = gamble)

  return(stan_data)
}

THE_MODEL_FUNCTION <- model_base(~~~~~)

