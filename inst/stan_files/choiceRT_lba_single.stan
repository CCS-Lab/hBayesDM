#include /pre/license.stan

// The model published in Annis, J., Miller, B. J., & Palmeri, T. J. (2016).
// Bayesian inference with Stan: A tutorial on adding custom distributions. Behavior research methods, 1-24.
functions {
  // declares lba_pdf, lba_cdf, lba_lpdf, lba_rng
#include /func/choiceRT_lba.stan
}

data {
  int N_choice;
  int N_cond;
  int tr_cond[N_cond];
  int max_tr;
  matrix[2, max_tr] RT[N_cond];
}

parameters {
  real<lower=0> d;
  real<lower=0> A;
  real<lower=0> tau;
  vector<lower=0>[N_choice] v[N_cond];
}

transformed parameters {
  real s;
  s = 1;
}

model {
  // Declare variables
  int n_trials;

  // Individual parameters
  d ~ normal(.5, 1)T[0,];
  A ~ normal(.5, 1)T[0,];
  tau ~ normal(.5, .5)T[0,];

  for (j in 1:N_cond) {
    // Store number of trials for subject/condition pair
    n_trials = tr_cond[j];

    for (n in 1:N_choice) {
      // Drift rate is normally distributed
      v[j, n] ~ normal(2, 1)T[0,];
    }
    // Likelihood of RT x Choice
    RT[j, , 1:n_trials] ~ lba(d, A, v[j,], s, tau);
  }
}

generated quantities {
  // Declare variables
  int n_trials;

  // For log likelihood calculation
  real log_lik;

  // For posterior predictive check
  matrix[2, max_tr] y_pred[N_cond];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (j in 1:N_cond) {
    for (t in 1:max_tr) {
      y_pred[j, , t] = rep_vector(-1, 2);
    }
  }

  // initialize log_lik
  log_lik = 0;

  { // local section, this saves time and space
    for (j in 1:N_cond) {
      // Store number of trials for subject/condition pair
      n_trials = tr_cond[j];

      // Sum likelihood over conditions within subjects
      log_lik += lba_lpdf(RT[j, , 1:n_trials] | d, A, v[j,], s, tau);

      for (t in 1:n_trials) {
          // generate posterior predictions
          y_pred[j, , t] = lba_rng(d, A, v[j,], s, tau);
        }
    }
  }
}

