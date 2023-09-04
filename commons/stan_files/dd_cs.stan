#include /include/license.stan

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
  vector[3] mu_pr;
  vector<lower=0>[3] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] r_pr;     // (exponential) discounting rate (Impatience)
  vector[N] s_pr;     // time-sensitivity
  vector[N] beta_pr;  // inverse temperature
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0, upper=1>[N]  r;
  vector<lower=0, upper=10>[N] s;
  vector<lower=0, upper=5>[N]  beta;

  for (i in 1:N) {
    r[i]    = Phi_approx(mu_pr[1] + sigma[1] * r_pr[i]);
    s[i]    = Phi_approx(mu_pr[2] + sigma[2] * s_pr[i]) * 10;
    beta[i] = Phi_approx(mu_pr[3] + sigma[3] * beta_pr[i]) * 5;
  }
}

model {
// Constant-sensitivity model (Ebert & Prelec, 2007)
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // individual parameters
  r_pr    ~ normal(0, 1);
  s_pr    ~ normal(0, 1);
  beta_pr ~ normal(0, 1);

  for (i in 1:N) {
    // Define values
    real ev_later;
    real ev_sooner;

    for (t in 1:(Tsubj[i])) {
      ev_later  = amount_later[i, t] * exp(-1* (pow(r[i] * delay_later[i, t], s[i])));
      ev_sooner = amount_sooner[i, t] * exp(-1* (pow(r[i] * delay_sooner[i, t], s[i])));
      choice[i, t] ~ bernoulli_logit(beta[i] * (ev_later - ev_sooner));
    }
  }
}
generated quantities {
  // For group level parameters
  real<lower=0, upper=1>  mu_r;
  real<lower=0, upper=10> mu_s;
  real<lower=0, upper=5>  mu_beta;

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

  mu_r    = Phi_approx(mu_pr[1]);
  mu_s    = Phi_approx(mu_pr[2]) * 10;
  mu_beta = Phi_approx(mu_pr[3]) * 5;

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define values
      real ev_later;
      real ev_sooner;

      log_lik[i] = 0;

      for (t in 1:(Tsubj[i])) {
        ev_later  = amount_later[i, t] * exp(-1* (pow(r[i] * delay_later[i, t], s[i])));
        ev_sooner = amount_sooner[i, t] * exp(-1* (pow(r[i] * delay_sooner[i, t], s[i])));
        log_lik[i] += bernoulli_logit_lpmf(choice[i, t] | beta[i] * (ev_later - ev_sooner));

        // generate posterior prediction for current trial
        y_pred[i, t] = bernoulli_rng(inv_logit(beta[i] * (ev_later - ev_sooner)));
      }
    }
  }
}

