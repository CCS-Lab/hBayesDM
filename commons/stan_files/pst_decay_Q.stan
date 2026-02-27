#include /pre/license.stan

data {
  int<lower=1> N;             // Number of subjects
  int<lower=1> T;             // Maximum # of trials
  int<lower=1> Tsubj[N];      // # of trials for acquisition phase

  int<lower=-1,upper=6> option1[N, T];
  int<lower=-1,upper=6> option2[N, T];
  int<lower=-1,upper=1> choice[N, T];
  real reward[N, T];
  real<lower=0> trial_gap[N, T]; // Gap between trials. 0 if trials were consecutive.
}

transformed data {
  // Default values to initialize the vector of expected values
  vector[6] initial_values;
  initial_values = rep_vector(0, 6);
}

parameters {
  // Group-level parameters
  vector[3] mu_pr;
  vector<lower=0>[3] sigma;

  // Subject-level parameters for Matt trick
  vector[N] alpha_pr;
  vector[N] beta_pr;
  vector[N] gamma_pr;
}

transformed parameters {
  vector<lower=0,upper=1>[N] alpha;
  vector<lower=0,upper=10>[N] beta;
  vector<lower=0,upper=1>[N] gamma;

  alpha = Phi_approx(mu_pr[1] + sigma[1] * alpha_pr);
  beta  = Phi_approx(mu_pr[2] + sigma[2] * beta_pr) * 10;
  gamma = Phi_approx(mu_pr[3] + sigma[3] * gamma_pr);
}

model {
  // Priors for group-level parameters
  mu_pr ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // Priors for subject-level parameters
  alpha_pr ~ normal(0, 1);
  beta_pr  ~ normal(0, 1);
  gamma_pr  ~ normal(0, 1);

  for (i in 1:N) {
    int co;          // Chosen option
    real delta;      // Difference between two options
    real pe;         // Prediction error
    vector[6] ev;    // Expected values
    real decay_rate; // How much expected values decayed

    ev = initial_values;

    // Acquisition Phase
    for (t in 1:Tsubj[i]) {
      co = (choice[i, t] > 0) ? option1[i, t] : option2[i, t];
      decay_rate = pow(gamma[i], trial_gap[i, t]);

      // Luce choice rule
      delta = (ev[option1[i, t]] * decay_rate) - (ev[option2[i, t]] * decay_rate);
      target += bernoulli_logit_lpmf(choice[i, t] | beta[i] * delta);

      pe = reward[i, t] - ev[co];
      ev[co] += alpha[i] * pe;
    }
  }
}

generated quantities {
  // For group-level parameters
  real<lower=0,upper=1>  mu_alpha;
  real<lower=0,upper=10> mu_beta;
  real<lower=0,upper=1>  mu_gamma;
  
  real pe[N, T]; // prediction error

  // For log-likelihood calculation
  real log_lik[N];

  // For posterior predictive check
  real<lower=0,upper=1> y_pred[N, T];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = 0;
    }
  }

  mu_alpha = Phi_approx(mu_pr[1]);
  mu_beta  = Phi_approx(mu_pr[2]) * 10;
  mu_gamma = Phi_approx(mu_pr[3]);

  {
    for (i in 1:N) {
      int co;          // Chosen option
      real delta;      // Difference between two options
      vector[6] ev;    // Expected values
      real decay_rate; // How much expected values decayed

      ev = initial_values;
      log_lik[i] = 0;

      // Acquisition Phase
      for (t in 1:Tsubj[i]) {
        co = (choice[i, t] > 0) ? option1[i, t] : option2[i, t];
        decay_rate = pow(gamma[i], trial_gap[i, t]);

        // Luce choice rule
        delta = (ev[option1[i, t]] * decay_rate) - (ev[option2[i, t]] * decay_rate);
        log_lik[i] += bernoulli_logit_lpmf(choice[i, t] | beta[i] * delta);

        // generate posterior prediction for current trial
        y_pred[i, t] = bernoulli_rng(inv_logit(beta[i] * delta));

        pe[i, t] = reward[i, t] - ev[co];
        ev[co] += alpha[i] * pe[i, t];
      }
    }
  }
}
