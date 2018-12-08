#include /pre/license.stan

data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  real<lower=0> gain[N, T];
  real<lower=0> loss[N, T];  // absolute loss amount
  real cert[N, T];
  int<lower=-1, upper=1> gamble[N, T];
}

transformed data {
}

parameters {
  vector[2] mu_pr;
  vector<lower=0>[2] sigma;
  vector[N] lambda_pr;
  vector[N] tau_pr;
}

transformed parameters {
  vector<lower=0, upper=5>[N] lambda;
  vector<lower=0, upper=5>[N] tau;

  for (i in 1:N) {
    lambda[i] = Phi_approx(mu_pr[1] + sigma[1] * lambda_pr[i]) * 5;
    tau[i]    = Phi_approx(mu_pr[2] + sigma[2] * tau_pr[i]) * 5;
  }
}

model {
  // ra_prospect: Original model in Soko-Hessner et al 2009 PNAS
  // hyper parameters
  mu_pr  ~ normal(0, 1.0);
  sigma ~ normal(0, 0.2);

  // individual parameters w/ Matt trick
  lambda_pr ~ normal(0, 1.0);
  tau_pr    ~ normal(0, 1.0);

  for (i in 1:N) {
    for (t in 1:Tsubj[i]) {
      real evSafe;    // evSafe, evGamble, pGamble can be a scalar to save memory and increase speed.
      real evGamble;  // they are left as arrays as an example for RL models.
      real pGamble;

      // loss[i, t]=absolute amount of loss (pre-converted in R)
      evSafe   = cert[i, t];
      evGamble = 0.5 * (gain[i, t] - lambda[i] * loss[i, t]);
      pGamble  = inv_logit(tau[i] * (evGamble - evSafe));
      gamble[i, t] ~ bernoulli(pGamble);
    }
  }
}
generated quantities {
  real<lower=0, upper=5> mu_lambda;
  real<lower=0, upper=5> mu_tau;

  real log_lik[N];

  // For posterior predictive check
  real y_pred[N, T];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = -1;
    }
  }

  mu_lambda = Phi_approx(mu_pr[1]) * 5;
  mu_tau    = Phi_approx(mu_pr[2]) * 5;

  { // local section, this saves time and space
    for (i in 1:N) {
      log_lik[i] = 0;
      for (t in 1:Tsubj[i]) {
        real evSafe;    // evSafe, evGamble, pGamble can be a scalar to save memory and increase speed.
        real evGamble;  // they are left as arrays as an example for RL models.
        real pGamble;

        evSafe   = cert[i, t];
        evGamble = 0.5 * (gain[i, t] - lambda[i] * loss[i, t]);
        pGamble    = inv_logit(tau[i] * (evGamble - evSafe));
        log_lik[i] += bernoulli_lpmf(gamble[i, t] | pGamble);

        // generate posterior prediction for current trial
        y_pred[i, t] = bernoulli_rng(pGamble);
      }
    }
  }
}

