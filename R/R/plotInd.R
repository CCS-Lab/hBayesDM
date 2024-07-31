#' Plots individual posterior distributions, using the stan_plot function of the rstan package
#'
#' @param obj An output of the hBayesDM. Its class should be 'hBayesDM'.
#' @param pars (from stan_plot's help file) Character vector of parameter names. If unspecified, show all user-defined parameters or the first 10 (if there are more than 10)
#' @param show_density T(rue) or F(alse). Show the density (T) or not (F)?
#' @param ...  (from stan_plot's help file) Optional additional named arguments passed to stan_plot, which will be passed to geoms. See stan_plot's help file.
#'
#' @importFrom ggplot2 ggplot geom_histogram theme xlab ylab geom_segment ggtitle aes
#' @importFrom rstan stan_plot
#'
#' @export
#'
#' @examples
#' \dontrun{
#' # Run a model
#' output <- dd_hyperbolic("example", 2000, 1000, 3, 3)
#'
#' # Plot the hyper parameters ('k' and 'beta')
#' plot(output)
#'
#' # Plot individual 'k' (discounting rate) parameters
#' plotInd(output, "k")
#'
#' # Plot individual 'beta' (inverse temperature) parameters
#' plotInd(output, "beta")
#'
#' # Plot individual 'beta' parameters but don't show density
#' plotInd(output, "beta", show_density = F)
#' }

plotInd <- function(obj = NULL,
                    pars,
                    # show_density = T, 
                    prob = 0.80, # JY added (default setting of stan_plot: ci_level = 80%)
                    prob_outer = 0.95, # JY added (default setting of stan_plot: outer_level = 95%)
                    ...) {
  # uses 'stan_plot' from the rstan pacakge
  # class of the object --> should be 'hBayesDM'
  
  # To pass R CMD Checks (serves no other purpose than to create binding)
  # ..density.. <- NULL # JY edited (mcmc_acrea doesn't need this line)
  
  parNames <- names(obj$parVals) #JY added 
  
  select_parameter <- function(pars, parNames) { #JY added 
    if (grepl("\\[", pars)){ 
      c(pars)}
    
    else{
      c(parNames[grepl(paste0("^", pars), parNames) & !grepl(paste0("^", pars, "_pr"), parNames)])
    } 
  }
  selected <- unlist(lapply(pars, select_parameter, parNames))
  
  h1 = mcmc_areas(obj$fit$draws(), pars = selected, prob = prob, prob_outer = prob_outer, ...) #JY edited 
  
  #   if (inherits(obj, "hBayesDM")) {
  #     h1 = rstan::stan_plot(obj$fit, pars, show_density = show_density, ...)
  #   } else {
  #     stop(paste0("\n\nThe class of the object (first argument) should be hBayesDM! \n"))
  #   }
  
  return(h1)
}