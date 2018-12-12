#include /pre/license.stan

data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  int<lower=-1, upper=2> choice[N, T];
  real outcome[N, T];  // no lower and upper bounds
}
transformed data {
  vector[2] initV;  // initial values for EV
  initV = rep_vector(0.0, 2);
}
parameters {
// Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[2] mu_pr;
  vector<lower=0>[2] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] A_pr;    // learning rate
  vector[N] tau_pr;  // inverse temperature
}
transformed parameters {
  // subject-level parameters
  vector<lower=0, upper=1>[N] A;
  vector<lower=0, upper=5>[N] tau;

  for (i in 1:N) {
    A[i]   = Phi_approx(mu_pr[1]  + sigma[1]  * A_pr[i]);
    tau[i] = Phi_approx(mu_pr[2] + sigma[2] * tau_pr[i]) * 5;
  }
}
model {
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // individual parameters
  A_pr   ~ normal(0, 1);
  tau_pr ~ normal(0, 1);

  // subject loop and trial loop
  for (i in 1:N) {
    vector[2] ev; // expected value
    real PE;      // prediction error

    ev = initV;

    for (t in 1:(Tsubj[i])) {
      // compute action probabilities
      choice[i, t] ~ categorical_logit(tau[i] * ev);

      // prediction error
      PE = outcome[i, t] - ev[choice[i, t]];

      // value updating (learning)
      ev[choice[i, t]] += A[i] * PE;
    }
  }
}
generated quantities {
  // For group level parameters
  real<lower=0, upper=1> mu_A;
  real<lower=0, upper=5> mu_tau;

  // For log likelihood calculation
  real log_lik[N];

  // For posterior predictive check
  real y_pred[N, T];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = -1;
    }
  }

  mu_A   = Phi_approx(mu_pr[1]);
  mu_tau = Phi_approx(mu_pr[2]) * 5;

  { // local section, this saves time and space
    for (i in 1:N) {
      vector[2] ev; // expected value
      real PE;      // prediction error

      // Initialize values
      ev = initV;

      log_lik[i] = 0;

      for (t in 1:(Tsubj[i])) {
        // compute log likelihood of current trial
        log_lik[i] += categorical_logit_lpmf(choice[i, t] | tau[i] * ev);

        // generate posterior prediction for current trial
        y_pred[i, t] = categorical_rng(softmax(tau[i] * ev));

        // prediction error
        PE = outcome[i, t] - ev[choice[i, t]];

        // value updating (learning)
        ev[choice[i, t]] += A[i] * PE;
      }
    }
  }
}

