#' Compute Highest-Density Interval
#'
#' @description 
#' Computes the highest density interval from a sample of representative values, estimated as shortest credible interval.
#' Downloaded from John Kruschke's website \url{http://www.indiana.edu/~kruschke/DoingBayesianDataAnalysis/}
#' 
#' @param sampleVec A vector of representative values from a probability distribution (e.g., MCMC samples).
#' @param credMass A scalar between 0 and 1, indicating the mass within the credible interval that is to be estimated.
#' 
#' @return A vector containing the limits of the HDI
#' 
#' @export 

HDIofMCMC = function(sampleVec, 
                     credMass = 0.95 ) {
  
    sortedPts = sort( sampleVec )
    ciIdxInc = floor( credMass * length( sortedPts ) )
    nCIs = length( sortedPts ) - ciIdxInc
    ciWidth = rep( 0 , nCIs )
    for ( i in 1:nCIs ) {
        ciWidth[ i ] = sortedPts[ i + ciIdxInc ] - sortedPts[ i ]
    }
    HDImin = sortedPts[ which.min( ciWidth ) ]
    HDImax = sortedPts[ which.min( ciWidth ) + ciIdxInc ]
    HDIlim = c( HDImin , HDImax )
    return( HDIlim )
}
