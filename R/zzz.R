#' @noRd
 
.onAttach <- function(libname, pkgname) {
  ver <- utils::packageVersion("hBayesDM")
  packageStartupMessage("\n\nThis is hBayesDM version ", ver, "\n\n")
}




