#include /pre/license.stan

// The model published in Annis, J., Miller, B. J., & Palmeri, T. J. (2016).
// Bayesian inference with Stan: A tutorial on adding custom distributions. Behavior research methods, 1-24.
functions {
  // declares lba_pdf, lba_cdf, lba_lpdf, lba_rng
#include /func/choiceRT_lba.stan
}

data {
  int N;
  int Max_tr;
  int N_choices;
  int N_cond;
  int N_tr_cond[N, N_cond];
  matrix[2, Max_tr] RT[N, N_cond];
}

parameters {
  // Hyperparameter means
  real<lower=0> mu_d;
  real<lower=0> mu_A;
  real<lower=0> mu_tau;
  vector<lower=0>[N_choices] mu_v[N_cond];

  // Hyperparameter sigmas
  real<lower=0> sigma_d;
  real<lower=0> sigma_A;
  real<lower=0> sigma_tau;
  vector<lower=0>[N_choices] sigma_v[N_cond];

  // Individual parameters
  real<lower=0> d[N];
  real<lower=0> A[N];
  real<lower=0> tau[N];
  vector<lower=0>[N_choices] v[N, N_cond];
}

transformed parameters {
  // s is set to 1 to make model identifiable
  real s;
  s = 1;
}

model {
  // Hyperparameter means
  mu_d   ~ normal(.5, 1)T[0,];
  mu_A   ~ normal(.5, 1)T[0,];
  mu_tau ~ normal(.5, .5)T[0,];

  // Hyperparameter sigmas
  sigma_d   ~ gamma(1, 1);
  sigma_A   ~ gamma(1, 1);
  sigma_tau ~ gamma(1, 1);

  // Hyperparameter means and sigmas for multiple drift rates
  for (j in 1:N_cond) {
    for (n in 1:N_choices) {
      mu_v[j, n]    ~ normal(2, 1)T[0,];
      sigma_v[j, n] ~ gamma(1, 1);
    }
  }

  for (i in 1:N) {
    // Declare variables
    int n_trials;

    // Individual parameters
    d[i]   ~ normal(mu_d, sigma_d)T[0,];
    A[i]   ~ normal(mu_A, sigma_A)T[0,];
    tau[i] ~ normal(mu_tau, sigma_tau)T[0,];

    for (j in 1:N_cond) {
      // Store number of trials for subject/condition pair
      n_trials = N_tr_cond[i, j];

      for (n in 1:N_choices) {
        // Drift rate is normally distributed
        v[i, j, n] ~ normal(mu_v[j, n], sigma_v[j, n])T[0,];
      }
      // Likelihood of RT x Choice
      RT[i, j, , 1:n_trials] ~ lba(d[i], A[i], v[i, j,], s, tau[i]);
    }
  }
}

generated quantities {
  // Declare variables
  int n_trials;

  // For log likelihood calculation
  real log_lik[N];

  // For posterior predictive check
  matrix[2, Max_tr] y_pred[N, N_cond];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (j in 1:N_cond) {
      for (t in 1:Max_tr) {
        y_pred[i, j, , t] = rep_vector(-1, 2);
      }
    }
  }

  { // local section, this saves time and space
    for (i in 1:N) {
      // Initialize variables
      log_lik[i] = 0;

      for (j in 1:N_cond) {
        // Store number of trials for subject/condition pair
        n_trials = N_tr_cond[i, j];

        // Sum likelihood over conditions within subjects
        log_lik[i] += lba_lpdf(RT[i, j, , 1:n_trials] | d[i], A[i], v[i, j,], s, tau[i]);

        for (t in 1:n_trials) {
          // generate posterior predictions
          y_pred[i, j, , t] = lba_rng(d[i], A[i], v[i, j,], s, tau[i]);
        }
      }
    }
    // end of subject loop
  }
}

