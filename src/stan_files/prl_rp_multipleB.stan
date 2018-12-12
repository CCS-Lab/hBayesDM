#include /pre/license.stan

/**
 * Probabilistic Reversal Learning (PRL) Task
 *
 * Reward-Punishment Model with multiple blocks per subject by Ouden et al. (2013) Neuron
 */

data {
  // declares N, B, Bsubj[N], T, Tsubj[N, B]
#include /data/NBT.stan
  // declares choice[N, B, T], outcome[N, B, T]
#include /data/choice_outcome_block.stan
}

transformed data {
  // Default value for (re-)initializing parameter vectors
  vector[2] initV;
  initV = rep_vector(0.0, 2);
}

// Declare all parameters as vectors for vectorizing
parameters {
  // Hyper(group)-parameters
  vector[3] mu_pr;
  vector<lower=0>[3] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] Apun_pr;   // learning rate (punishment)
  vector[N] Arew_pr;   // learning rate (reward)
  vector[N] beta_pr;   // inverse temperature
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0, upper=1>[N] Apun;
  vector<lower=0, upper=1>[N] Arew;
  vector<lower=0, upper=10>[N] beta;

  for (i in 1:N) {
    Apun[i]  = Phi_approx(mu_pr[1] + sigma[1] * Apun_pr[i]);
    Arew[i]  = Phi_approx(mu_pr[2] + sigma[2] * Arew_pr[i]);
    beta[i]  = Phi_approx(mu_pr[3] + sigma[3] * beta_pr[i]) * 10;
  }
}

model {
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // individual parameters
  Apun_pr ~ normal(0, 1);
  Arew_pr ~ normal(0, 1);
  beta_pr ~ normal(0, 1);

  for (i in 1:N) {
    for (bIdx in 1:Bsubj[i]) {  // new
      // Define Values
      vector[2] ev;   // Expected value
      real PE;        // Prediction error

      // Initialize values
      ev = initV;     // Initial ev values

      for (t in 1:Tsubj[i, bIdx]) {
        // Softmax choice
        choice[i, bIdx, t] ~ categorical_logit(ev * beta[i]);

        // Prediction Error
        PE = outcome[i, bIdx, t] - ev[choice[i, bIdx, t]];

        // Update expected value of chosen stimulus
        if (outcome[i, bIdx, t] > 0)
          ev[choice[i, bIdx, t]] += Arew[i] * PE;
        else
          ev[choice[i, bIdx, t]] += Apun[i] * PE;
      }
    }
  }
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=1> mu_Apun;
  real<lower=0, upper=1> mu_Arew;
  real<lower=0, upper=10> mu_beta;

  // For log likelihood calculation
  real log_lik[N];

  // For model regressors
  real ev_c[N, B, T];   // Expected value of the chosen option
  real ev_nc[N, B, T];  // Expected value of the non-chosen option
  real pe[N, B, T];     // Prediction error

  // For posterior predictive check
  real y_pred[N, B, T];

  // Initialize all the variables to avoid NULL values
  for (i in 1:N) {
    for (b in 1:B) {
      for (t in 1:T) {
        ev_c[i, b, t]  = 0;
        ev_nc[i, b, t] = 0;
        pe[i, b, t]    = 0;

        y_pred[i, b, t]   = -1;
      }
    }
  }

  mu_Apun = Phi_approx(mu_pr[1]);
  mu_Arew = Phi_approx(mu_pr[2]);
  mu_beta = Phi_approx(mu_pr[3]) * 10;

  { // local section, this saves time and space
    for (i in 1:N) {

      log_lik[i] = 0;

      for (bIdx in 1:Bsubj[i]) {  // new
        // Define values
        vector[2] ev; // Expected value
        real PE; // prediction error

        // Initialize values
        ev = initV; // initial ev values

        for (t in 1:Tsubj[i, bIdx]) {
          // Softmax choice
          log_lik[i] += categorical_logit_lpmf(choice[i, bIdx, t] | ev * beta[i]);

          // generate posterior prediction for current trial
          y_pred[i, bIdx, t] = categorical_rng(softmax(ev * beta[i]));

          // Prediction Error
          PE = outcome[i, bIdx, t] - ev[choice[i, bIdx, t]];

          // Store values for model regressors
          ev_c[i, bIdx, t]   = ev[choice[i, bIdx, t]];
          ev_nc[i, bIdx, t]  = ev[3 - choice[i, bIdx, t]];
          pe[i, bIdx, t]     = PE;

          // Update expected value of chosen stimulus
          if (outcome[i, bIdx, t] > 0)
            ev[choice[i, bIdx, t]] += Arew[i] * PE;
          else
            ev[choice[i, bIdx, t]] += Apun[i] * PE;
        }
      }
    }
  }
}

