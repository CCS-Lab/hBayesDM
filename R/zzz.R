#' @noRd

.onAttach <- function(libname, pkgname) {
  ver <- utils::packageVersion("hBayesDM")
  packageStartupMessage("\n\nThis is hBayesDM version ", ver, "\n\n")
}

.onLoad <- function(libname, pkgname) { # nocov start
  if (FLAG_BUILD_AT_ONCE) {
    modules <- paste0("stan_fit4", names(stanmodels), "_mod")
    for (m in modules) loadModule(m, what = TRUE)
  }
} # nocov end

