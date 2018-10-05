// based on codes/comments by Guido Biele, Joseph Burling, Andrew Ellis, and potentially others @ Stan mailing lists
data {
  int<lower=1> N;      // Number of subjects
  int<lower=0> Nu_max; // Max (across subjects) number of upper boundary responses
  int<lower=0> Nl_max; // Max (across subjects) number of lower boundary responses
  int<lower=0> Nu[N];  // Number of upper boundary responses for each subj
  int<lower=0> Nl[N];  // Number of lower boundary responses for each subj
  real RTu[N, Nu_max];  // upper boundary response times
  real RTl[N, Nl_max];  // lower boundary response times
  real minRT[N];       // minimum RT for each subject of the observed data
  real RTbound;        // lower bound or RT across all subjects (e.g., 0.1 second)
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

  // Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[4] mu_p;
  vector<lower=0>[4] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] alpha_pr;
  vector[N] beta_pr;
  vector[N] delta_pr;
  vector[N] tau_pr;
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0>[N]         alpha; // boundary separation
  vector<lower=0, upper=1>[N] beta;  // initial bias
  vector<lower=0>[N]         delta; // drift rate
  vector<lower=RTbound, upper=max(minRT)>[N] tau; // nondecision time

  for (i in 1:N) {
    beta[i] = Phi_approx(mu_p[2] + sigma[2] * beta_pr[i]);
    tau[i]  = Phi_approx(mu_p[4] + sigma[4] * tau_pr[i]) * (minRT[N]-RTbound) + RTbound;
  }
  alpha = exp(mu_p[1] + sigma[1] * alpha_pr);
  delta = exp(mu_p[3] + sigma[3] * delta_pr);
}

model {
  // Hyperparameters
  mu_p  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // Individual parameters for non-centered parameterization
  alpha_pr ~ normal(0, 1);
  beta_pr  ~ normal(0, 1);
  delta_pr ~ normal(0, 1);
  tau_pr   ~ normal(0, 1);

  // Begin subject loop
  for (i in 1:N) {
    // Response time distributed along wiener first passage time distribution
    RTu[i, :Nu[i]] ~ wiener(alpha[i], tau[i], beta[i], delta[i]);
    RTl[i, :Nl[i]] ~ wiener(alpha[i], tau[i], 1-beta[i], -delta[i]);

  } // end of subject loop
}

generated quantities {
  // For group level parameters
  real<lower=0>         mu_alpha; // boundary separation
  real<lower=0, upper=1> mu_beta;  // initial bias
  real<lower=0>         mu_delta; // drift rate
  real<lower=RTbound, upper=max(minRT)> mu_tau; // nondecision time

  // For log likelihood calculation
  real log_lik[N];

  // Assign group level parameter values
  mu_alpha = exp(mu_p[1]);
  mu_beta  = Phi_approx(mu_p[2]);
  mu_delta = exp(mu_p[3]);
  mu_tau   = Phi_approx(mu_p[4]) * (mean(minRT)-RTbound) + RTbound;

  { // local section, this saves time and space
    // Begin subject loop
    for (i in 1:N) {
      log_lik[i] = wiener_lpdf(RTu[i, :Nu[i]] | alpha[i], tau[i], beta[i], delta[i]);
      log_lik[i] = log_lik[i] + wiener_lpdf(RTl[i, :Nl[i]] | alpha[i], tau[i], 1-beta[i], -delta[i]);
    }
  }
}

