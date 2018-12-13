#' @noRd
if (Sys.getenv('HBAYESDM_BUILD_AT_ONCE') == "true") {
  FLAG_BUILD_AT_ONCE <- TRUE
} else {
  FLAG_BUILD_AT_ONCE <- FALSE
}
