#include /pre/license.stan

data {
  int<lower=1> N;             // Number of subjects
  int<lower=1> T;             // Maximum # of trials
  array[N] int<lower=1> Tsubj;      // # of trials for acquisition phase

  array[N,T] int<lower=-1,upper=6> option1;
  array[N,T] int<lower=-1,upper=6> option2;
  array[N,T] int<lower=-1,upper=1> choice;
  array[N,T] real reward;
}

transformed data {
  // Default values to initialize the vector of expected values
  vector[6] initial_values;
  initial_values = rep_vector(0, 6);
}

parameters {
  // Group-level parameters
  vector[2] mu_pr;
  vector<lower=0>[2] sigma;

  // Subject-level parameters for Matt trick
  vector[N] alpha_pr;
  vector[N] beta_pr;
}

transformed parameters {
  vector<lower=0,upper=1>[N] alpha;
  vector<lower=0,upper=10>[N] beta;

  alpha     = Phi_approx(mu_pr[1] + sigma[1] * alpha_pr);
  beta      = Phi_approx(mu_pr[2] + sigma[2] * beta_pr) * 10;
}

model {
  // Priors for group-level parameters
  mu_pr    ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // Priors for subject-level parameters
  alpha_pr ~ normal(0, 1);
  beta_pr      ~ normal(0, 1);

  for (i in 1:N) {
    int co;         // Chosen option
    real delta;     // Difference between two options
    real pe;        // Prediction error
    //real alpha;
    vector[6] ev;   // Expected values

    ev = initial_values;

    // Acquisition Phase
    for (t in 1:Tsubj[i]) {
      co = (choice[i, t] > 0) ? option1[i, t] : option2[i, t];

      // Luce choice rule
      delta = ev[option1[i, t]] - ev[option2[i, t]];
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

  // For log-likelihood calculation
  array[N] real log_lik;

  mu_alpha     = Phi_approx(mu_pr[1]);
  mu_beta      = Phi_approx(mu_pr[2]) * 10;

  {
    for (i in 1:N) {
      int co;         // Chosen option
      real delta;     // Difference between two options
      real pe;        // Prediction error
      //real alpha;
      vector[6] ev;   // Expected values

      ev = initial_values;
      log_lik[i] = 0;

      // Acquisition Phase
      for (t in 1:Tsubj[i]) {
        co = (choice[i, t] > 0) ? option1[i, t] : option2[i, t];

        // Luce choice rule
        delta = ev[option1[i, t]] - ev[option2[i, t]];
        log_lik[i] += bernoulli_logit_lpmf(choice[i, t] | beta[i] * delta);

        pe = reward[i, t] - ev[co];
        ev[co] += alpha[i] * pe;
      }
    }
  }
}

