#include /pre/license.stan

data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  real offer[N, T];
  int<lower=-1, upper=1> accept[N, T];
}

transformed data {
}

parameters {
// Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[3] mu_pr;
  vector<lower=0>[3] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] alpha_pr;  // alpha: Envy (sensitivity to norm prediction error)
  vector[N] tau_pr;    // tau: Inverse temperature
  vector[N] ep_pr;     // ep: Norm adaptation rate
}

transformed parameters {
  // Transform subject-level raw parameters
  real<lower=0, upper=20> alpha[N];
  real<lower=0, upper=10> tau[N];
  real<lower=0, upper=1> ep[N];

  for (i in 1:N) {
    alpha[i] = Phi_approx(mu_pr[1] + sigma[1] * alpha_pr[i]) * 20;
    tau[i]   = Phi_approx(mu_pr[2] + sigma[2] * tau_pr[i]) * 10;
    ep[i]    = Phi_approx(mu_pr[3] + sigma[3] * ep_pr[i]);
  }
}

model {
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // individual parameters
  alpha_pr ~ normal(0, 1.0);
  tau_pr   ~ normal(0, 1.0);
  ep_pr    ~ normal(0, 1.0);

  for (i in 1:N) {
    // Define values
    real f;    // Internal norm
    real PE;   // Prediction error
    real util; // Utility of offer

    // Initialize values
    f = 10.0;

    for (t in 1:Tsubj[i]) {
      // calculate prediction error
      PE = offer[i, t] - f;

      // Update utility
      util = offer[i, t] - alpha[i] * fmax(f - offer[i, t], 0.0);

      // Sampling statement
      accept[i, t] ~ bernoulli_logit(util * tau[i]);

      // Update internal norm
      f += ep[i] * PE;

    } // end of t loop
  } // end of i loop
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=20> mu_alpha;
  real<lower=0, upper=10> mu_tau;
  real<lower=0, upper=1> mu_ep;

  // For log likelihood calculation
  real log_lik[N];

  // For posterior predictive check
  real y_pred[N, T];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = -1;
    }
  }

  mu_alpha = Phi_approx(mu_pr[1]) * 20;
  mu_tau   = Phi_approx(mu_pr[2]) * 10;
  mu_ep    = Phi_approx(mu_pr[3]);

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define values
      real f;    // Internal norm
      real PE;   // prediction error
      real util; // Utility of offer

      // Initialize values
      f = 10.0;
      log_lik[i] = 0.0;

      for (t in 1:Tsubj[i]) {
        // calculate prediction error
        PE = offer[i, t] - f;

        // Update utility
        util = offer[i, t] - alpha[i] * fmax(f - offer[i, t], 0.0);

        // Calculate log likelihood
        log_lik[i] += bernoulli_logit_lpmf(accept[i, t] | util * tau[i]);

        // generate posterior prediction for current trial
        y_pred[i, t] = bernoulli_rng(inv_logit(util * tau[i]));

        // Update internal norm
        f += ep[i] * PE;

      } // end of t loop
    } // end of i loop
  } // end of local section
}

