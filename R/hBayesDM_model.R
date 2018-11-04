#' hBayesDM Model Base Function
#'
#' @description
#' The base function from which all hBayesDM model functions are created.
#'
#' Contributor: \href{https://ccs-lab.github.io/team/jethro-lee/}{Jethro Lee}
#'
#' @export
#' @keywords internal
#'
#' @include stanmodels.R
#' @importFrom utils head
#' @importFrom stats complete.cases qnorm median
#' @importFrom data.table fread
#' @importFrom parallel detectCores
#' @importFrom rstan stan_model vb sampling extract
#'
#' @param task_name Character value for name of task. E.g. \code{"gng"}.
#' @param model_name Character value for name of model. E.g. \code{"m1"}.
#' @param model_type Character value for modeling type: \code{""} OR \code{"single"} OR \code{"multipleB"}.
#' @param data_columns Character vector of necessary column names for the data. E.g. \code{c("subjID", "cue", "keyPressed", "outcome")}.
#' @param parameters List of parameters, with information about their lower bound, plausible value, upper bound. E.g. \code{list("xi" = c(0, 0.1, 1), "ep" = c(0, 0.2, 1), "rho" = c(0, exp(2), Inf))}.
#' @param regressors List of regressors, with information about their extracted dimensions. E.g. \code{list("Qgo" = 2, "Qnogo" = 2, "Wgo" = 2, "Wnogo" = 2)}. OR if model-based regressors are not available for this model, \code{NULL}.
#' @param postpreds Character vector of name(s) for the trial-level posterior predictive simulations. Default is \code{"y_pred"}. OR if posterior predictions are not yet available for this model, \code{NULL}.
#' @param stanmodel_arg Leave as \code{NULL} (default) for completed models. Else should either be a character value (specifying the name of a Stan file) OR a \code{stanmodel} object (returned as a result of running \code{\link[rstan]{stan_model}}).
#' @param preprocess_func Function to preprocess the raw data before it gets passed to Stan.
#'
#' @details
#' \strong{task_name}: Typically same task models share the same data column requirements.
#'
#' \strong{model_name}: Typically different models are distinguished by their different list of parameters.
#'
#' \strong{model_type} is one of the following three:
#' \describe{
#'  \item{\code{""}}{Modeling of multiple subjects. (Default hierarchical Bayesian analysis.)}
#'  \item{\code{"single"}}{Modeling of a single subject.}
#'  \item{\code{"multipleB"}}{Modeling of multiple subjects, where multiple blocks exist within each subject.}
#' }
#'
#' \strong{data_columns} must be the entirety of necessary data columns used at some point in the R or Stan code. I.e. \code{"subjID"} must always be included. In the case of 'multipleB' type models, \code{"block"} should also be included as well.
#'
#' \strong{parameters} is a list object, whose keys are the parameters of this model. Each parameter key must be assigned a numeric vector holding 3 elements: the parameter's lower bound, plausible value, and upper bound.
#'
#' \strong{regressors} is a list object, whose keys are the model-based regressors of this model. Each regressor key must be assigned a numeric value indicating the number of dimensions its data will be extracted as. If model-based regressors are not available for this model, this argument should just be \code{NULL}.
#'
#' \strong{postpreds} defaults to \code{"y_pred"}, but any other character vector holding appropriate names is possible (c.f. Two-Step Task models). If posterior predictions are not yet available for this model, this argument should just be \code{NULL}.

hBayesDM_model <- function(task_name,
                           model_name,
                           model_type = "",
                           data_columns,
                           parameters,
                           regressors = NULL,
                           postpreds = "y_pred",
                           stanmodel_arg = NULL,
                           preprocess_func) {

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

    # Check if postpred available for this model
    if (inc_postpred && is.null(postpreds)) {
      stop("** Posterior predictions are not yet available for this model. **\n")
    }

    # For using "example" or "choose" data
    if (data == "example") {
      if (model_type == "") {
        exampleData <- paste0(task_name, "_", "exampleData.txt")
      } else {
        exampleData <- paste0(task_name, "_", model_type, "_", "exampleData.txt")
      }
      data <- system.file("extdata", exampleData, package = "hBayesDM")
    } else if (data == "choose") {
      data <- file.choose()
    }

    # Check if data file exists
    if (!file.exists(data)) {
      stop("** Data file does not exist. Please check again. **\n",
           "  e.g. data = \"MySubFolder/myData.txt\"\n")
    }

    # Load the data
    raw_data <- data.table::fread(file = data, header = TRUE, sep = "\t", data.table = TRUE,
                                  fill = TRUE, stringsAsFactors = TRUE, logical01 = FALSE)
    # NOTE: Separator is fixed to "\t" because fread() has trouble reading space delimited files with missing values.

    # Save initial colnames of raw_data for later
    colnames_raw_data <- colnames(raw_data)

    # Check if necessary data columns all exist (while ignoring case and underscores)
    insensitive_data_columns <- tolower(gsub("_", "", data_columns, fixed = TRUE))
    colnames(raw_data) <- tolower(gsub("_", "", colnames(raw_data), fixed = TRUE))
    if (!all(insensitive_data_columns %in% colnames(raw_data))) {
      stop("** Data file is missing one or more necessary data columns. Please check again. **\n",
           "  Necessary data columns are: \"", paste0(data_columns, collapse = "\", \""), "\".\n")
    }

    # Remove only the rows containing NAs in necessary columns
    complete_rows       <- complete.cases(raw_data[, insensitive_data_columns])
    sum_incomplete_rows <- sum(!complete_rows)
    if (sum_incomplete_rows > 0) {
      raw_data <- raw_data[complete_rows, ]
      cat("\n")
      cat("The following lines of the data file have NAs in necessary columns:\n")
      cat(paste0(head(which(!complete_rows), 100) + 1, collapse = ", "))
      if (sum_incomplete_rows > 100) {
        cat(", ...")
      }
      cat(" (total", sum_incomplete_rows, "lines)\n")
      cat("These rows are removed prior to modeling the data.\n")
    }

    ####################################################
    ##   Prepare general info about the raw data   #####
    ####################################################

    subjs    <- NULL   # List of unique subjects (1D)
    n_subj   <- NULL   # Total number of subjects (0D)

    b_subjs  <- NULL   # Number of blocks per each subject (1D)
    b_max    <- NULL   # Maximum number of blocks across all subjects (0D)

    t_subjs  <- NULL   # Number of trials (per block) per subject (2D or 1D)
    t_max    <- NULL   # Maximum number of trials across all blocks & subjects (0D)

    if (model_type != "multipleB") {
      DT_trials <- raw_data[, .N, by = "subjid"]
      subjs     <- DT_trials$subjid
      n_subj    <- length(subjs)
      t_subjs   <- DT_trials$N
      t_max     <- max(t_subjs)
      if ((model_type == "single") && (n_subj != 1)) {
        stop("** More than 1 unique subjects exist in data file, while using 'single' type model. **\n")
      }
    } else {
      DT_trials <- raw_data[, .N, by = c("subjid", "block")]
      DT_blocks <- DT_trials[, .N, by = "subjid"]
      subjs     <- DT_blocks$subjid
      n_subj    <- length(subjs)
      b_subjs   <- DT_blocks$N
      b_max     <- max(b_subjs)
      t_subjs   <- array(0, c(n_subj, b_max))
      for (i in 1:n_subj) {
        subj <- subjs[i]
        b <- b_subjs[i]
        t_subjs[i, 1:b] <- DT_trials[subjid == subj]$N
      }
      t_max     <- max(t_subjs)
    }

    general_info <- list(subjs, n_subj, b_subjs, b_max, t_subjs, t_max)
    names(general_info) <- c("subjs", "n_subj", "b_subjs", "b_max", "t_subjs", "t_max")

    #########################################################
    ##   Prepare: data_list                             #####
    ##            pars                                  #####
    ##            init            for passing to Stan   #####
    #########################################################

    # Preprocess the raw data to pass to Stan
    data_list <- preprocess_func(raw_data, general_info)

    # The parameters of interest for Stan
    pars <- c(paste0("mu_", names(parameters)),
              "sigma",
              names(parameters),
              "log_lik")
    if (modelRegressor) {
      pars <- c(pars, names(regressors))
    }
    if (inc_postpred) {
      pars <- c(pars, postpreds)
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
          lb <- parameters[[i]][1]                    # lower bound
          ub <- parameters[[i]][3]                    # upper bound
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
        group_level             <- list(mu_pr = primes,
                                        sigma = rep(1.0, length(primes)))
        individual_level        <- lapply(primes, function(x) rep(x, n_subj))
        names(individual_level) <- paste0(names(parameters), "_pr")
        return(c(group_level, individual_level))
      }
    }

    ############### Print for user ###############

    # Full name of model
    model <- paste0(task_name, "_", model_name)

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

    # Print for user
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
    cat(" # of subjects                  =  ", n_subj, "\n", sep = "")
    if (model_type == "multipleB") {
      cat(" # of (max) blocks per subject  =  ", b_max, "\n", sep = "")
    }
    cat(" # of (max) trials per subject  =  ", t_max, "\n", sep = "")

    ############### Fit & extract ###############

    # Designate the Stan model
    if (is.null(stanmodel_arg)) {
      if (FLAG_GITHUB_VERSION) {
        stanmodel_arg <- stanmodels[[model]]
        cat("\n")
        cat("************************************\n")
        cat("**  Loading a pre-compiled model  **\n")
        cat("************************************\n")
      } else {
        stanmodel_arg <- system.file("exec", paste0(model, ".stan"), package = "hBayesDM")
      }
    }
    if (is.character(stanmodel_arg)) {
      stanmodel_arg <- rstan::stan_model(stanmodel_arg)
    }

    # Fit the Stan model
    if (vb) {   # if variational Bayesian
      fit <- rstan::vb(object = stanmodel_arg,
                       data   = data_list,
                       pars   = pars,
                       init   = init)
    } else {
      fit <- rstan::sampling(object  = stanmodel_arg,
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

    # Trial-level posterior predictive simulations
    if (inc_postpred) {
      for (pp in postpreds) {
        parVals[[pp]][parVals[[pp]] == -1] <- NA
      }
    }

    # Define measurement of individual parameters
    measure_indPars <- switch(indPars, mean = mean, median = median, mode = estimate_mode)

    # Measure all individual parameters (per subject)
    allIndPars <- as.data.frame(array(NA, c(n_subj, length(parameters))))
    for (i in 1:n_subj) {
      allIndPars[i, ] <- mapply(function(x) measure_indPars(parVals[[x]][, i]), names(parameters))
    }
    allIndPars <- cbind(subjs, allIndPars)
    colnames(allIndPars) <- c("subjID", names(parameters))

    # Model regressors (for model-based neuroimaging, etc.)
    if (modelRegressor) {
      model_regressor <- list()
      for (r in names(regressors)) {
        model_regressor[[r]] <- apply(parVals[[r]], c(1:regressors[[r]]) + 1, measure_indPars)
      }
      cat("\n")
      cat("**************************************\n")
      cat("**  Extract model-based regressors  **\n")
      cat("**************************************\n")
    }

    # Give back initial colnames and revert to data.frame
    colnames(raw_data) <- colnames_raw_data
    raw_data <- as.data.frame(raw_data)

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

    # Object class information
    class(modelData) <- "hBayesDM"

    # Inform user of completion
    cat("\n")
    cat("************************************\n")
    cat("**** Model fitting is complete! ****\n")
    cat("************************************\n")

    return(modelData)
  }
}


