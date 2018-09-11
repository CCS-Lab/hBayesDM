/**
 * Probabilistic Reversal Learning (PRL) Task
 *
 * Fictitious Update Model (Glascher et al., 2008, Cerebral Cortex) without alpha (indecision point)
 */

data {
  int<lower=1> N;                       // Number of subjects
  int<lower=1> T;                       // Maximum number of trials across subjects
  int<lower=1, upper=T> Tsubj[N];       // Number of trials/blocks for each subject
  int<lower=-1, upper=2> choice[N, T];  // The choices subjects made
  real outcome[N, T];                   // The outcome
}

transformed data {
  // Default value for (re-)initializing parameter vectors
  vector[2] initV;
  initV = rep_vector(0.0, 2);
}

// Declare all parameters as vectors for vectorizing
parameters {
  // Hyper(group)-parameters
  vector[2] mu_p;
  vector<lower=0>[2] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] eta_pr;   // learning rate
  vector[N] beta_pr;  // inverse temperature
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0, upper=1>[N] eta;
  vector<lower=0, upper=5>[N] beta;

  for (i in 1:N) {
    eta[i]   = Phi_approx(mu_p[1] + sigma[1] * eta_pr[i]);
    beta[i]  = Phi_approx(mu_p[2] + sigma[2] * beta_pr[i]) * 5;
  }
}

model {
  // Hyperparameters
  mu_p  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // Individual parameters
  eta_pr    ~ normal(0, 1);
  beta_pr   ~ normal(0, 1);

  for (i in 1:N) {
    // Define values
    vector[2] ev;    // expected value
    vector[2] prob;  // probability

    real PE;     // prediction error
    real PEnc;   // fictitious prediction error (PE-non-chosen)

    // Initialize values
    ev = initV; // initial ev values

    for (t in 1:(Tsubj[i])) {
      // Compute action probabilities
      prob[1] = 1 / (1 + exp(beta[i] * (ev[2] - ev[1])));
      prob[2] = 1 - prob[1];
      choice[i, t] ~ categorical(prob);

      // Prediction error
      PE   =  outcome[i, t] - ev[choice[i, t]];
      PEnc = -outcome[i, t] - ev[3-choice[i, t]];

      // Value updating (learning)
      ev[choice[i, t]]   = ev[choice[i, t]]   + eta[i] * PE;
      ev[3-choice[i, t]] = ev[3-choice[i, t]] + eta[i] * PEnc;
    }
  }
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=1> mu_eta;
  real<lower=0, upper=5> mu_beta;

  // For log likelihood calculation
  real log_lik[N];

  // For model regressors
  real mr_ev_c[N, T];    // Expected value of the chosen option
  real mr_ev_nc[N, T];   // Expected value of the non-chosen option

  real mr_pe_c[N, T];   //Prediction error of the chosen option
  real mr_pe_nc[N, T];  //Prediction error of the non-chosen option
  real mr_dv[N, T];     //Decision value = PE_chosen - PE_non-chosen

  // For posterior predictive check
  real y_pred[N, T];

  // Set all posterior predictions, model regressors to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      mr_ev_c[i, t] = 0;
      mr_ev_nc[i, t] = 0;

      mr_pe_c[i, t] = 0;
      mr_pe_nc[i, t] = 0;
      mr_dv[i, t] =0;

      y_pred[i, t] = -1;
    }
  }

  mu_eta    = Phi_approx(mu_p[1]);
  mu_beta   = Phi_approx(mu_p[2]) * 5;

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define values
      vector[2] ev;     // expected value
      vector[2] prob;   // probability

      real PE;          // prediction error
      real PEnc;        // fictitious prediction error (PE-non-chosen)

      // Initialize values
      ev = initV; // initial ev values

      log_lik[i] = 0;

      for (t in 1:(Tsubj[i])) {
        // compute action probabilities
        prob[1] = 1 / (1 + exp(beta[i] * (ev[2] - ev[1])));
        prob[2] = 1 - prob[1];

        log_lik[i] = log_lik[i] + categorical_lpmf(choice[i, t] | prob);

        // generate posterior prediction for current trial
        y_pred[i, t] = categorical_rng(prob);

        // prediction error
        PE   =  outcome[i, t] - ev[choice[i, t]];
        PEnc = -outcome[i, t] - ev[3-choice[i, t]];

        // Store values for model regressors
        mr_ev_c[i, t]   = ev[choice[i, t]];
        mr_ev_nc[i, t]  = ev[3 - choice[i, t]];

        mr_pe_c[i, t]   = PE;
        mr_pe_nc[i, t]  = PEnc;
        mr_dv[i, t]     = PE - PEnc;

        // value updating (learning)
        ev[choice[i, t]]   += eta[i] * PE;
        ev[3-choice[i, t]] += eta[i] * PEnc;
      }
    }
  }
}

