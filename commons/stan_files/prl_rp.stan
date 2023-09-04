#include /include/license.stan

/**
 * Probabilistic Reversal Learning (PRL) Task
 *
 * Reward-Punishment Model by Ouden et al. (2013) Neuron
 */

data {
  int<lower=1> N;                       // Number of subjects
  int<lower=1> T;                       // Maximum number of trials across subjects
  array[N] int<lower=1, upper=T> Tsubj;       // Number of trials/blocks for each subject

  array[N, T] int<lower=-1, upper=2> choice;  // The choices subjects made
  array[N, T] real outcome;                   // The outcome
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
  vector<lower=0, upper=1>[N]  Apun;
  vector<lower=0, upper=1>[N]  Arew;
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
    // Define Values
    vector[2] ev;   // Expected value
    real PE;        // prediction error

    // Initialize values
    ev = initV;     // initial ev values

    for (t in 1:Tsubj[i]) {
      // Softmax choice
      choice[i, t] ~ categorical_logit(ev * beta[i]);

      // Prediction Error
      PE = outcome[i, t] - ev[choice[i, t]];

      // Update expected value of chosen stimulus
      if (outcome[i, t] > 0)
        ev[choice[i, t]] += Arew[i] * PE;
      else
        ev[choice[i, t]] += Apun[i] * PE;
    }
  }
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=1>  mu_Apun;
  real<lower=0, upper=1>  mu_Arew;
  real<lower=0, upper=10> mu_beta;

  // For log likelihood calculation
  array[N] real log_lik;

  // For model regressors
  array[N, T] real ev_c;   // Expected value of the chosen option
  array[N, T] real ev_nc;  // Expected value of the non-chosen option
  array[N, T] real pe;     // Prediction error

  // For posterior predictive check
  array[N, T] real y_pred;

  // Initialize all the variables to avoid NULL values
  for (i in 1:N) {
    for (t in 1:T) {
      ev_c[i, t]   = 0;
      ev_nc[i, t]  = 0;
      pe[i, t]     = 0;

      y_pred[i, t]    = -1;
    }
  }

  mu_Apun = Phi_approx(mu_pr[1]);
  mu_Arew = Phi_approx(mu_pr[2]);
  mu_beta = Phi_approx(mu_pr[3]) * 10;

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define values
      vector[2] ev; // Expected value
      real PE;      // Prediction error

      // Initialize values
      ev = initV; // initial ev values
      log_lik[i] = 0;

      for (t in 1:Tsubj[i]) {
        // Softmax choice
        log_lik[i]  += categorical_logit_lpmf(choice[i, t] | ev * beta[i]);

        // generate posterior prediction for current trial
        y_pred[i, t] = categorical_rng(softmax(ev * beta[i]));

        // Prediction Error
        PE = outcome[i, t] - ev[choice[i, t]];

        // Store values for model regressors
        ev_c[i, t]   = ev[choice[i, t]];
        ev_nc[i, t]  = ev[3 - choice[i, t]];
        pe[i, t]     = PE;

        // Update expected value of chosen stimulus
        if (outcome[i, t] > 0)
          ev[choice[i, t]] += Arew[i] * PE;
        else
          ev[choice[i, t]] += Apun[i] * PE;
      }
    }
  }
}

