#' Compute Highest-Density Interval
#'
#' @description
#' Computes the highest density interval from a sample of representative values,
#' estimated as shortest credible interval.
#' Based on John Kruschke's codes.
#'
#' @param sample_vec A vector of representative values from a probability distribution (e.g., MCMC samples).
#' @param ci_prob A scalar between 0 and 1, indicating the mass within the credible interval that is to be estimated.
#'
#' @return A vector containing the limits of the HDI
#'
#' @export

hdi = function(sample_vec,
                     ci_prob = 0.95) {

    sortedPts = sort(sample_vec)
    ciIdxInc = floor(ci_prob * length(sortedPts))
    nCIs = length(sortedPts) - ciIdxInc
    ciWidth = rep(0 , nCIs)
    for (i in 1:nCIs) {
        ciWidth[i] = sortedPts[i + ciIdxInc] - sortedPts[i]
    }
    HDImin = sortedPts[which.min(ciWidth)]
    HDImax = sortedPts[which.min(ciWidth) + ciIdxInc]
    HDIlim = c(HDImin , HDImax)
    return(HDIlim)
}
