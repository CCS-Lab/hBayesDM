#include /pre/license.stan

/**
 * Probabilistic Reversal Learning (PRL) Task
 *
 * Experience-Weighted Attraction model by Ouden et al. (2013) Neuron
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
  vector[3] mu_pr;
  vector<lower=0>[3] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] phi_pr;     // 1-learning rate
  vector[N] rho_pr;     // experience decay factor
  vector[N] beta_pr;    // inverse temperature
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0, upper=1>[N]  phi;
  vector<lower=0, upper=1>[N]  rho;
  vector<lower=0, upper=10>[N] beta;

  for (i in 1:N) {
    phi[i]  = Phi_approx(mu_pr[1] + sigma[1] * phi_pr[i]);
    rho[i]  = Phi_approx(mu_pr[2] + sigma[2] * rho_pr[i]);
    beta[i] = Phi_approx(mu_pr[3] + sigma[3] * beta_pr[i]) * 10;
  }
}

model {
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // Individual parameters
  phi_pr  ~ normal(0, 1);
  rho_pr  ~ normal(0, 1);
  beta_pr ~ normal(0, 1);

  for (i in 1:N) {
    // Define values
    vector[2] ev; // Expected value
    vector[2] ew; // Experience weight

    real ewt1; // Experience weight of trial (t - 1)

    // Initialize values
    ev = initV; // initial ev values
    ew = initV; // initial ew values

    for (t in 1:Tsubj[i]) {
      // Softmax choice
      choice[i, t] ~ categorical_logit(ev * beta[i]);

      // Store previous experience weight value
      ewt1 = ew[choice[i, t]];

      // Update experience weight for chosen stimulus
      {
        ew[choice[i, t]] *= rho[i];
        ew[choice[i, t]] += 1;
      }

      // Update expected value of chosen stimulus
      {
        ev[choice[i, t]] *= phi[i] * ewt1;
        ev[choice[i, t]] += outcome[i, t];
        ev[choice[i, t]] /= ew[choice[i, t]];
      }
    }
  }
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=1>  mu_phi;
  real<lower=0, upper=1>  mu_rho;
  real<lower=0, upper=10> mu_beta;

  // For log likelihood calculation
  real log_lik[N];

  // For model regressors
  //real mr_ev[N, T, 2];   // Expected value
  real ev_c[N, T];    // Expected value of the chosen option
  real ev_nc[N, T];   // Expected value of the non-chosen option

  //real mr_ew[N, T, 2];   // Experience weight
  real ew_c[N, T];    // Experience weight of the chosen option
  real ew_nc[N, T];   // Experience weight of the non-chosen option

  // For posterior predictive check
  real y_pred[N, T];

  // Set all posterior predictions, model regressors to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      ev_c[i, t] = 0;
      ev_nc[i, t] = 0;
      ew_c[i, t] = 0;
      ew_nc[i, t] = 0;

      y_pred[i, t] = -1;
    }
  }

  mu_phi  = Phi_approx(mu_pr[1]);
  mu_rho  = Phi_approx(mu_pr[2]);
  mu_beta = Phi_approx(mu_pr[3]) * 10;

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define values
      vector[2] ev; // Expected value
      vector[2] ew; // Experience weight

      real ewt1; // Experience weight of trial (t-1)

      // Initialize values
      ev = initV; // initial ev values
      ew = initV; // initial ew values

      log_lik[i] = 0;

      for (t in 1:Tsubj[i]) {
        // Softmax choice
        log_lik[i] += categorical_logit_lpmf(choice[i, t] | ev * beta[i]);

        // generate posterior prediction for current trial
        y_pred[i, t] = categorical_rng(softmax(ev * beta[i]));

        // Store values for model regressors
        //mr_ev[i, t]    = ev;
        ev_c[i, t]  = ev[choice[i, t]];
        ev_nc[i, t] = ev[3 - choice[i, t]];

        //mr_ew[i, t]    = ew;
        ew_c[i, t]  = ew[choice[i, t]];
        ew_nc[i, t] = ew[3 - choice[i, t]];

        // Store previous experience weight value
        ewt1 = ew[choice[i, t]];

        // Update experience weight for chosen stimulus
        {
          ew[choice[i, t]] *= rho[i];
          ew[choice[i, t]] += 1;
        }

        // Update expected value of chosen stimulus
        {
          ev[choice[i, t]] *= phi[i] * ewt1;
          ev[choice[i, t]] += outcome[i, t];
          ev[choice[i, t]] /= ew[choice[i, t]];
        }
      }
    }
  }
}

