/**
 * Probabilistic Reversal Learning (PRL) Task
 *
 * Fictitious Update Model (Glascher et al., 2008, Cerebral Cortex) with separate learning rates for +PE and -PE & without alpha (indecision point)
 */

data {
  int<lower=1> N;                                     // Number of subjects
  int<lower=1> T;                                     // Max number of trials across subjects
  int<lower=1, upper=T> Tsubj[N];                     // Number of trials/blocks for each subject
  int<lower=-1, upper=2> choice[N, T];                // The choices subjects made
  real outcome[N, T];                                 // The outcome
}

transformed data {
  // Default value for (re-)initializing parameter vectors
  vector[2] initV;
  initV = rep_vector(0.0, 2);
}

// Declare all parameters as vectors for vectorizing
parameters {
  // Hyper(group)-parameters
  vector[3] mu_p;
  vector<lower=0>[3] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] eta_pos_pr;   // learning rate, positive PE
  vector[N] eta_neg_pr;   // learning rate, negative PE
  vector[N] beta_pr;      // inverse temperature
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0, upper=1>[N] eta_pos;
  vector<lower=0, upper=1>[N] eta_neg;
  vector<lower=0, upper=5>[N] beta;

  for (i in 1:N) {
    eta_pos[i]  = Phi_approx(mu_p[1] + sigma[1] * eta_pos_pr[i]);
    eta_neg[i]  = Phi_approx(mu_p[2] + sigma[2] * eta_neg_pr[i]);
    beta[i]     = Phi_approx(mu_p[3] + sigma[3] * beta_pr[i]) * 5;
  }
}

model {
  // Hyperparameters
  mu_p  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // individual parameters
  eta_pos_pr ~ normal(0, 1);
  eta_neg_pr ~ normal(0, 1);
  beta_pr    ~ normal(0, 1);

  for (i in 1:N) {
    // Define values
    vector[2] ev;     // expected value
    vector[2] prob;   // probability

    real pe_c;    // prediction error
    real pe_nc;   // fictitious prediction error (PE-non-chosen)

    // Initialize values
    ev = initV;   // initial ev values

    for (t in 1:(Tsubj[i])) {
      // compute action probabilities
      prob[1] = 1 / (1 + exp(beta[i] * (ev[2] - ev[1])));
      prob[2] = 1 - prob[1];
      choice[i, t] ~ categorical(prob);

      // prediction error
      pe_c  =  outcome[i, t] - ev[choice[i, t]];
      pe_nc = -outcome[i, t] - ev[3 - choice[i, t]];

      // value updating (learning)
      if (pe_c >= 0) {
        ev[choice[i, t]]      += eta_pos[i] * pe_c;
        ev[3 - choice[i, t]]  += eta_pos[i] * pe_nc;
      } else {
        ev[choice[i, t]]      += eta_neg[i] * pe_c;
        ev[3 - choice[i, t]]  += eta_neg[i] * pe_nc;
      }
    }
  }
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=1> mu_eta_pos;
  real<lower=0, upper=1> mu_eta_neg;
  real<lower=0, upper=5> mu_beta;

  // For log likelihood calculation
  real log_lik[N];

  // For model regressors
  real mr_ev_c[N, T];   // Expected value of the chosen option
  real mr_ev_nc[N, T];  // Expected value of the non-chosen option

  real mr_pe_c[N, T];   // Prediction error of the chosen option
  real mr_pe_nc[N, T];  // Prediction error of the non-chosen option

  real mr_dv[N, T];     // Decision value = PE_chosen - PE_non-chosen

  // For posterior predictive check
  real y_pred[N, T];

  // Initialize all the variables to avoid NULL values
  for (i in 1:N) {
    for (t in 1:T) {
      mr_ev_c[i, t]   = 0;
      mr_ev_nc[i, t]  = 0;
      mr_pe_c[i, t]   = 0;
      mr_pe_nc[i, t]  = 0;
      mr_dv[i, t]     = 0;

      y_pred[i, t]    = -1;
    }
  }

  mu_eta_pos = Phi_approx(mu_p[1]);
  mu_eta_neg = Phi_approx(mu_p[2]);
  mu_beta    = Phi_approx(mu_p[3]) * 5;

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define values
      vector[2] ev;     // expected value
      vector[2] prob;   // probability

      real pe_c;    // prediction error
      real pe_nc;   // fictitious prediction error (PE-non-chosen)

      // Initialize values
      ev = initV;   // initial ev values

      log_lik[i] = 0;

      for (t in 1:(Tsubj[i])) {
        // compute action probabilities
        prob[1] = 1 / (1 + exp(beta[i] * (ev[2] - ev[1])));
        prob[2] = 1 - prob[1];

        log_lik[i]  += categorical_lpmf(choice[i, t] | prob);

        // generate posterior prediction for current trial
        y_pred[i, t] = categorical_rng(prob);

        // prediction error
        pe_c  =  outcome[i, t] - ev[choice[i, t]];
        pe_nc = -outcome[i, t] - ev[3 - choice[i, t]];

        // Store values for model regressors
        mr_ev_c[i, t]   = ev[choice[i, t]];
        mr_ev_nc[i, t]  = ev[3 - choice[i, t]];
        mr_pe_c[i, t]   = pe_c;
        mr_pe_nc[i, t]  = pe_nc;
        mr_dv[i, t]     = pe_c - pe_nc;

        // Value updating (learning)
        if (pe_c >= 0) {
          ev[choice[i, t]]      += eta_pos[i] * pe_c;
          ev[3 - choice[i, t]]  += eta_pos[i] * pe_nc;
        } else {
          ev[choice[i, t]]      += eta_neg[i] * pe_c;
          ev[3 - choice[i, t]]  += eta_neg[i] * pe_nc;
        }
      }
    }
  }
}

