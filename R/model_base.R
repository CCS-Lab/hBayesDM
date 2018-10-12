#' @param task_name Name of the task, e.g. \code{"gng"}.
#' @param model_name Name of the model, e.g. \code{"m1"}.
#' @param model_type One of the following three: \code{NULL} OR \code{"single"} OR \code{"multipleB"}.
#' @param data_columns Names of the necessary columns for the data, e.g. \code{c("subjID", "cue", "keyPressed", "outcome")}. Must be the entirety of necessary data columns that will be used at some point in the code, i.e. must always include \code{"subjID"}, and should include \code{"block"} in the case of 'multipleB' type models.
#' @param parameters A list object whose keys are the parameters of this model. Each parameter key must be assigned a numeric vector of 3 elements: the parameter's lower bound, plausible value, and upper bound. E.g. \code{list("xi" = c(0, 0.1, 1), "ep" = c(0, 0.2, 1), "rho" = c(0, exp(2.0), Inf))}.
#' @param regressors Names of the model-based regressors, e.g. \code{c("Qgo", "Qnogo", "Wgo", "Wnogo")}; OR if model-based regressors are not available for this model, \code{NULL}.
#' @param preprocess_function The model-specific function to preprocess the raw data to pass to Stan. Takes a data.frame object \code{raw_data} as argument, and returns a list object \code{data_list}.

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

    #########################################################
    ##   Prepare: data_list                             #####
    ##            pars                                  #####
    ##            init            for passing to Stan   #####
    #########################################################

    # Preprocess the raw data to pass to Stan
    data_list <- preprocess_function(raw_data)

    # The parameters of interest for Stan
    pars <- c(paste0("mu_", names(parameters)),
              "sigma",
              names(parameters),
              "log_lik")

    if (modelRegressor) {
      pars <- c(pars, regressors)
    }

    if (inc_postpred) {
      pars <- c(pars, "y_pred")
    }

    # Initial values for the parameters
    if (inits[1] == "random") {
      init <- "random"
    } else {
      if (inits[1] == "fixed") {
        inits <- unlist(lapply(parameters, "[", 2))   # plausible values of each parameter
      }
      if (length(inits) != length(parameters)) {
        stop("** Length of 'inits' must be ", length(parameters),
             " (= the number of parameters of this model). Please check again. **\n")
      }
      init <- function() {
        primes <- vector()
        for (i in 1:length(parameters)) {
          lb <- parameters[[i]][1]   # lower bound
          ub <- parameters[[i]][3]   # upper bound
          if (is.finite(lb) && (lb != 0)) {
            warning("Message to Dev: This is the first occurrence of a finite non-zero",
                    " lower bound for a parameter. Please make sure to re-adjust the",
                    " Stan file(s) accordingly, then move on to delete this warning.\n")
          }
          if (is.infinite(lb)) {
            primes[i] <- inits[i]                             # (-Inf, Inf)
          } else if (is.infinite(ub)) {
            primes[i] <- log(inits[i] - lb)                   # (  lb, Inf)
          } else {
            primes[i] <- qnorm((inits[i] - lb) / (ub - lb))   # (  lb,  ub)
          }
        }
        group_level          <- list(mu_p  = primes,
                                     sigma = rep(1.0, length(primes)))
        indiv_level          <- lapply(primes, function(x) rep(x, data_list$N))
        names(indiv_level)   <- paste0(names(parameters), "_p")
        return(c(group_level, indiv_level))
      }
    }

    ############### Print info ###############

    # Set number of cores for parallel computing
    if (ncore <= 1) {
      ncore <- 1
    } else {
      local_cores <- parallel::detectCores()
      if (ncore > local_cores) {
        ncore <- local_cores
        warning("Number of cores specified for parallel computing greater than",
                " number of locally available cores. Using all locally available cores.\n")
      }
    }
    options(mc.cores = ncore)

    # Information for user
    model <- paste0(task_name, "_", model_name)
    cat("\n")
    cat("Model name  =  ", model, "\n", sep = "")
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
    cat(" # of subjects                  =  ", data_list$N, "\n", sep = "")
    if (!is.null(model_type) && model_type == "multipleB") {
      cat(" # of (max) blocks per subject  =  ", data_list$maxB, "\n", sep = "")
    }
    cat(" # of (max) trials per subject  =  ", data_list$T, "\n", sep = "")

    ############### Fit & extract ###############

    # Path to .stan file
    if (FLAG_CRAN_VERSION) {
      m <- rstan::stan_model(system.file("stan", paste0(model, ".stan"), package = "hBayesDM"))
    } else {
      m <- stanmodels$model
      cat("\n")
      cat("************************************\n")
      cat("**  Loading a pre-compiled model  **\n")
      cat("************************************\n")
    }

    # Fit the Stan model
    if (vb) {   # if variational Bayesian
      fit <- rstan::vb(m,
                       data   = data_list,
                       pars   = pars,
                       init   = init)
    } else {
      fit <- rstan::sampling(m,
                             data    = data_list,
                             pars    = pars,
                             init    = init,
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

    # Define measurement of individual parameters
    measure_indPars <- switch(indPars, mean = mean, median = median, mode = estimate_mode)

    # Measure all individual parameters (per subject)
    allIndPars <- as.data.frame(array(NA, c(data_list$N, length(parameters))))
    for (i in 1:data_list$N) {
      allIndPars[i, ] <- mapply(function(x) measure_indPars(parVals[[x]][, i]), names(parameters))
    }
    allIndPars <- cbind(data_list$ID, allIndPars)
    colnames(allIndPars) <- c("subjID", names(parameter))

    # Model regressors (for model-based neuroimaging, etc.)
    if (modelRegressor) {
      cat("\n")
      cat("**************************************\n")
      cat("**  Extract model-based regressors  **\n")
      cat("**************************************\n")

      model_regressor <- lapply(regressors, function(x) apply(parVals[[x]], c(2, 3), measure_indPars))
      names(model_regressor) <- regressors
    }

    # Wrap up data into a list
    modelData                   <- list()
    modelData$model             <- model
    modelData$allIndPars        <- allIndPars
    modelData$parVals           <- parVals
    modelData$fit               <- fit
    modelData$rawdata           <- raw_data
    if (modelRegressor) {
      modelData$modelRegressor  <- model_regressor
    }

    class(modelData) <- "hBayesDM"

    # Inform user of completion
    cat("\n")
    cat("************************************\n")
    cat("**** Model fitting is complete! ****\n")
    cat("************************************\n")

    return(modelData)
  }
}

