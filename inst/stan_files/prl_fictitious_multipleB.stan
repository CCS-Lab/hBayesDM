#include /pre/license.stan

/**
 * Probabilistic Reversal Learning (PRL) Task
 *
 * Fictitious Update Model (Glascher et al., 2008, Cerebral Cortex)
 */

data {
  int<lower=1> N;                          // Number of subjects

  int<lower=1> B;                          // Max number of blocks across subjects
  int<lower=1> Bsubj[N];                   // Number of blocks for each subject

  int<lower=0> T;                          // Max number of trials across subjects
  int<lower=0, upper=T> Tsubj[N, B];       // Number of trials/block for each subject

  int<lower=-1, upper=2> choice[N, B, T];  // Choice for each subject-block-trial
  real outcome[N, B, T];                   // Outcome (reward/loss) for each subject-block-trial
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
    eta[i]    = Phi_approx(mu_pr[1] + sigma[1] * eta_pr[i]);
    beta[i]   = Phi_approx(mu_pr[3] + sigma[3] * beta_pr[i]) * 10;
  }
  alpha = mu_pr[2] + sigma[2] * alpha_pr;
}
model {
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma[1] ~ normal(0, 0.2);
  sigma[2] ~ cauchy(0, 1.0);
  sigma[3] ~ normal(0, 0.2);

  // individual parameters
  eta_pr    ~ normal(0, 1);
  alpha_pr  ~ normal(0, 1);
  beta_pr   ~ normal(0, 1);

  for (i in 1:N) {
    for (bIdx in 1:Bsubj[i]) {  // new
      // Define values
      vector[2] ev;    // expected value
      vector[2] prob;  // probability
      real prob_1_;

      real PE;     // prediction error
      real PEnc;   // fictitious prediction error (PE-non-chosen)

      // Initialize values
      ev = initV; // initial ev values

      for (t in 1:(Tsubj[i, bIdx])) {  // new
        // compute action probabilities
        prob[1] = 1 / (1 + exp(beta[i] * (alpha[i] - (ev[1] - ev[2]))));
        prob_1_ = prob[1];
        prob[2] = 1 - prob_1_;
        choice[i, bIdx, t] ~ categorical(prob);
        //choice[i, t] ~ bernoulli(prob);

        // prediction error
        PE   =  outcome[i, bIdx, t] - ev[choice[i, bIdx, t]];  //new
        PEnc = -outcome[i, bIdx, t] - ev[3-choice[i, bIdx, t]];  //new

        // value updating (learning)
        ev[choice[i, bIdx, t]]   += eta[i] * PE;   //new
        ev[3-choice[i, bIdx, t]] += eta[i] * PEnc;  //new
      } // end of t loop
    } // end of bIdx loop
  } // end of i loop
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=1> mu_eta;
  real mu_alpha;
  real<lower=0, upper=10> mu_beta;

  // For log likelihood calculation
  real log_lik[N];

  // For model regressors
  real ev_c[N, B, T];           // Expected value of the chosen option
  real ev_nc[N, B, T];          // Expected value of the non-chosen option

  real pe_c[N, B, T];           //Prediction error of the chosen option
  real pe_nc[N, B, T];          //Prediction error of the non-chosen option
  real dv[N, B, T];             //Decision value = PE_chosen - PE_non-chosen

  // For posterior predictive check
  real y_pred[N, B, T];

  // Set all posterior predictions, model regressors to 0 (avoids NULL values)
  for (i in 1:N) {
    for (b in 1:B) {
      for (t in 1:T) {
        ev_c[i, b, t] = 0;
        ev_nc[i, b, t] = 0;

        pe_c[i, b, t] = 0;
        pe_nc[i, b, t] = 0;
        dv[i, b, t] = 0;

        y_pred[i, b, t] = -1;
      }
    }
  }

  mu_eta    = Phi_approx(mu_pr[1]);
  mu_alpha  = mu_pr[2];
  mu_beta   = Phi_approx(mu_pr[3]) * 10;

  { // local section, this saves time and space
    for (i in 1:N) {

      log_lik[i] = 0;

      for (bIdx in 1:Bsubj[i]) {
        // Define values
        vector[2] ev;     // expected value
        vector[2] prob;   // probability
        real prob_1_;

        real PE;     // prediction error
        real PEnc;   // fictitious prediction error (PE-non-chosen)

        // Initialize values
        ev = initV; // initial ev values

        for (t in 1:(Tsubj[i, bIdx])) {
          // compute action probabilities
          prob[1] = 1 / (1 + exp(beta[i] * (alpha[i] - (ev[1] - ev[2]))));
          prob_1_ = prob[1];
          prob[2] = 1 - prob_1_;

          log_lik[i] += categorical_lpmf(choice[i, bIdx, t] | prob);  //new

          // generate posterior prediction for current trial
          y_pred[i, bIdx, t] = categorical_rng(prob);

          // prediction error
          PE   =  outcome[i, bIdx, t] - ev[choice[i, bIdx, t]];  //new
          PEnc = -outcome[i, bIdx, t] - ev[3-choice[i, bIdx, t]];  //new

          // Store values for model regressors
          ev_c[i, bIdx, t]   = ev[choice[i, bIdx, t]];
          ev_nc[i, bIdx, t]  = ev[3 - choice[i, bIdx, t]];

          pe_c[i, bIdx, t]   = PE;
          pe_nc[i, bIdx, t]  = PEnc;
          dv[i, bIdx, t]     = PE - PEnc;

          // value updating (learning)
          ev[choice[i, bIdx, t]]   += eta[i] * PE;   //new
          ev[3-choice[i, bIdx, t]] += eta[i] * PEnc;  //new
        } // end of t loop
      } // end of bIdx loop
    }
  }
}

