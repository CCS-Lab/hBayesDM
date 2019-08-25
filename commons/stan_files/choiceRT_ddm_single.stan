#include /pre/license.stan

// based on codes/comments by Guido Biele, Joseph Burling, Andrew Ellis, and potentially others @ Stan mailing lists
data {
  int<lower=0> Nu; // of upper boundary responses
  int<lower=0> Nl; // of lower boundary responses
  real RTu[Nu];    // upper boundary response times
  real RTl[Nl];    // lower boundary response times
  real minRT;      // minimum RT of the observed data
  real RTbound;    // lower bound or RT (e.g., 0.1 second)
}

parameters {
  // parameters of the DDM (parameter names in Ratcliffs DDM), from https://github.com/gbiele/stan_wiener_test/blob/master/stan_wiener_test.R
  // also see: https://groups.google.com/forum///!searchin/stan-users/wiener%7Csort:relevance/stan-users/-6wJfA-t2cQ/Q8HS-DXgBgAJ
  // alpha (a): Boundary separation or Speed-accuracy trade-off (high alpha means high accuracy). alpha > 0
  // beta (b): Initial bias Bias for either response (beta > 0.5 means bias towards "upper" response 'A'). 0 < beta < 1
  // delta (v): Drift rate Quality of the stimulus (delta close to 0 means ambiguous stimulus or weak ability). 0 < delta
  // tau (ter): Nondecision time + Motor response time + encoding time (high means slow encoding, execution). 0 < ter (in seconds)
  ///* upper boundary of tau must be smaller than minimum RT
  //to avoid zero likelihood for fast responses.
  //tau can for physiological reasone not be faster than 0.1 s.*/

  real<lower=0, upper=5> alpha;  // boundary separation
  real<lower=0, upper=1> beta;   // initial bias
  real delta;  // drift rate
  real<lower=RTbound, upper=minRT> tau;  // nondecision time
}

model {
  alpha ~ uniform(0, 5);
  beta  ~ uniform(0, 1);
  delta ~ normal(0, 2);
  tau ~ uniform(RTbound, minRT);

  RTu ~ wiener(alpha, tau, beta, delta);
  RTl ~ wiener(alpha, tau, 1-beta, -delta);
}

generated quantities {

  // For log likelihood calculation
  real log_lik;

  // For posterior predictive check (Not implementeed yet)
  // vector[Nu] y_pred_upper;
  // vector[Nl] y_pred_lower;

  { // local section, this saves time and space
    log_lik = wiener_lpdf(RTu | alpha, tau, beta, delta);
    log_lik += wiener_lpdf(RTl | alpha, tau, 1-beta, -delta);

    // generate posterior predictions (Not implemented yet)
    // y_pred_upper = wiener_rng(alpha, tau, beta, delta);
    // y_pred_lower = wiener_rng(alpha, tau, 1-beta, -delta);
  }
}

