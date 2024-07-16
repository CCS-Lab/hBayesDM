#include /pre/license.stan

data {
  int<lower=1> N;
  int<lower=1> T;
  array[N] int<lower=1, upper=T> Tsubj;
  array[N, T] real<lower=0> delay_later;
  array[N, T] real<lower=0> amount_later;
  array[N, T] real<lower=0> delay_sooner;
  array[N, T] real<lower=0> amount_sooner;
  array[N, T] int<lower=-1, upper=1> choice; // 0 for instant reward, 1 for delayed reward
}

transformed data {
}

parameters {
// Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[2] mu_pr;
  vector<lower=0>[2] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] k_pr;
  vector[N] beta_pr;
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0, upper=1>[N] k;
  vector<lower=0, upper=5>[N] beta;

  for (i in 1:N) {
    k[i]    = Phi_approx(mu_pr[1] + sigma[1] * k_pr[i]);
    beta[i] = Phi_approx(mu_pr[2] + sigma[2] * beta_pr[i]) * 5;
  }
}

model {
// Hyperbolic function
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // individual parameters
  k_pr    ~ normal(0, 1);
  beta_pr ~ normal(0, 1);

  for (i in 1:N) {
    // Define values
    real ev_later;
    real ev_sooner;

    for (t in 1:(Tsubj[i])) {
      ev_later   = amount_later[i, t]  / (1 + k[i] * delay_later[i, t]);
      ev_sooner  = amount_sooner[i, t] / (1 + k[i] * delay_sooner[i, t]);
      choice[i, t] ~ bernoulli_logit(beta[i] * (ev_later - ev_sooner));
    }
  }
}
generated quantities {
  // For group level parameters
  real<lower=0, upper=1> mu_k;
  real<lower=0, upper=5> mu_beta;

  // For log likelihood calculation
  array[N] real log_lik;

  // For posterior predictive check
  array[N, T] real y_pred;

  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = -1;
    }
  }

  mu_k    = Phi_approx(mu_pr[1]);
  mu_beta = Phi_approx(mu_pr[2]) * 5;

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define values
      real ev_later;
      real ev_sooner;

      log_lik[i] = 0;

      for (t in 1:(Tsubj[i])) {
        ev_later   = amount_later[i, t]  / (1 + k[i] * delay_later[i, t]);
        ev_sooner  = amount_sooner[i, t] / (1 + k[i] * delay_sooner[i, t]);
        log_lik[i] += bernoulli_logit_lpmf(choice[i, t] | beta[i] * (ev_later - ev_sooner));

        // generate posterior prediction for current trial
        y_pred[i, t] = bernoulli_rng(inv_logit(beta[i] * (ev_later - ev_sooner)));
      }
    }
  }
}

