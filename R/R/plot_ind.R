#' Plots individual posterior distributions using \pkg{bayesplot}.
#'
#' @param obj An output of hBayesDM. Its class should be \code{'hBayesDM'}.
#' @param pars Character vector of parameter names to plot.
#' @param show_density If \code{TRUE}, draws posterior densities via
#'   \code{bayesplot::mcmc_areas}; otherwise draws point intervals via
#'   \code{bayesplot::mcmc_intervals}.
#' @param ... Additional arguments forwarded to the underlying \pkg{bayesplot} function.
#'
#' @importFrom ggplot2 ggplot geom_histogram theme xlab ylab geom_segment ggtitle aes
#' @importFrom bayesplot mcmc_areas
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
#' plot_ind(output, "k")
#'
#' # Plot individual 'beta' (inverse temperature) parameters
#' plot_ind(output, "beta")
#'
#' # Plot individual 'beta' parameters but don't show density
#' plot_ind(output, "beta", show_density = F)
#' }

plot_ind <- function(obj = NULL,
                    pars,
                    show_density = T, ...) {

  # To pass R CMD Checks (serves no other purpose than to create binding)
  ..density.. <- NULL

  if (inherits(obj, "hBayesDM")) {
    if (show_density) {
      h1 <- bayesplot::mcmc_areas(obj$fit$draws(pars), ...)
    } else {
      h1 <- bayesplot::mcmc_intervals(obj$fit$draws(pars), ...)
    }
  } else {
    stop(paste0("\n\nThe class of the object (first argument) should be hBayesDM! \n"))
  }
  return(h1)
}
