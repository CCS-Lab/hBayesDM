#include /pre/license.stan

/**
 * Probabilistic Reversal Learning (PRL) Task
 *
 * Fictitious Update Model (Glascher et al., 2008, Cerebral Cortex)
 */

data {
  // declares N, B, Bsubj[N], T, Tsubj[N, B]
#include /data/NT.stan
  // declares choice[N, T], outcome[N, T]
#include /data/choice_outcome.stan
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
  vector[N] eta_pr;   // learning rate
  vector[N] alpha_pr; // indecision point
  vector[N] beta_pr;  // inverse temperature
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0, upper=1>[N] eta;
  vector[N] alpha;
  vector<lower=0, upper=10>[N] beta;

  for (i in 1:N) {
    eta[i]   = Phi_approx(mu_pr[1] + sigma[1] * eta_pr[i]);
    beta[i]  = Phi_approx(mu_pr[3] + sigma[3] * beta_pr[i]) * 10;
  }
  alpha = mu_pr[2] + sigma[2] * alpha_pr;
}

model {
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma[1] ~ normal(0, 0.2);
  sigma[2] ~ cauchy(0, 1.0);
  sigma[3] ~ normal(0, 0.2);

  // Individual parameters
  eta_pr    ~ normal(0, 1);
  alpha_pr  ~ normal(0, 1);
  beta_pr   ~ normal(0, 1);

  for (i in 1:N) {
    // Define values
    vector[2] ev;    // expected value
    vector[2] prob;  // probability
    real prob_1_;

    real PE;     // prediction error
    real PEnc;   // fictitious prediction error (PE-non-chosen)

    // Initialize values
    ev = initV; // initial ev values

    for (t in 1:(Tsubj[i])) {
      // Compute action probabilities
      prob[1] = 1 / (1 + exp(beta[i] * (alpha[i] - (ev[1] - ev[2]))));
      prob_1_ = prob[1];
      prob[2] = 1 - prob_1_;
      choice[i, t] ~ categorical(prob);

      // Prediction error
      PE   =  outcome[i, t] - ev[choice[i, t]];
      PEnc = -outcome[i, t] - ev[3-choice[i, t]];

      // Value updating (learning)
      ev[choice[i, t]]   += eta[i] * PE;
      ev[3-choice[i, t]] += eta[i] * PEnc;
    }
  }
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=1> mu_eta;
  real mu_alpha;
  real<lower=0, upper=10> mu_beta;

  // For log likelihood calculation
  real log_lik[N];

  // For model regressors
  real ev_c[N, T];    // Expected value of the chosen option
  real ev_nc[N, T];   // Expected value of the non-chosen option

  real pe_c[N, T];   //Prediction error of the chosen option
  real pe_nc[N, T];  //Prediction error of the non-chosen option
  real dv[N, T];     //Decision value = PE_chosen - PE_non-chosen

  // For posterior predictive check
  real y_pred[N, T];

  // Set all posterior predictions, model regressors to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      ev_c[i, t] = 0;
      ev_nc[i, t] = 0;

      pe_c[i, t] = 0;
      pe_nc[i, t] = 0;
      dv[i, t] = 0;

      y_pred[i, t] = -1;
    }
  }

  mu_eta    = Phi_approx(mu_pr[1]);
  mu_alpha  = mu_pr[2];
  mu_beta   = Phi_approx(mu_pr[3]) * 10;

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define values
      vector[2] ev;     // expected value
      vector[2] prob;   // probability
      real prob_1_;

      real PE;          // prediction error
      real PEnc;        // fictitious prediction error (PE-non-chosen)

      // Initialize values
      ev = initV; // initial ev values

      log_lik[i] = 0;

      for (t in 1:(Tsubj[i])) {
        // compute action probabilities
        prob[1] = 1 / (1 + exp(beta[i] * (alpha[i] - (ev[1] - ev[2]))));
        prob_1_ = prob[1];
        prob[2] = 1 - prob_1_;

        log_lik[i] += categorical_lpmf(choice[i, t] | prob);

        // generate posterior prediction for current trial
        y_pred[i, t] = categorical_rng(prob);

        // prediction error
        PE   =  outcome[i, t] - ev[choice[i, t]];
        PEnc = -outcome[i, t] - ev[3-choice[i, t]];

        // Store values for model regressors
        ev_c[i, t]   = ev[choice[i, t]];
        ev_nc[i, t]  = ev[3 - choice[i, t]];

        pe_c[i, t]   = PE;
        pe_nc[i, t]  = PEnc;
        dv[i, t]     = PE - PEnc;

        // value updating (learning)
        ev[choice[i, t]]   += eta[i] * PE;
        ev[3-choice[i, t]] += eta[i] * PEnc;
      }
    }
  }
}

