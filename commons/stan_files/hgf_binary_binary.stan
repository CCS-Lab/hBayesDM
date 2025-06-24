#include /pre/license.stan

// Hierarchical Gaussian Filter from Mathys et al. (2011) https://doi.org/10.3389/fnhum.2011.00039

functions {
  // x ∈ (-inf, +inf) => y ∈ (a, b)
  real inv_logit_with_bounds(real x, real a, real b) {
    return a + (b - a) * inv_logit(x);
  }

  vector inv_logit_with_bounds_vector(vector x, real a, real b) {
    return a + (b - a) * inv_logit(x);
  }

  real softplus(real z) {
    if (z > 20) {
      return z; // avoid overflow in exp(z)
    } else {
      return log1p_exp(z); // numerically stable version of log(1 + exp(z))
    }
  }
}

data {
  int<lower=1> N; // number of subjects
  int<lower=1> T; // maximum number of trials for each subject
  int<lower=3> L; // level of hierarchy // TODO: make the code accept more than level 3

  int<lower=1> data_length;                              // sum of all the valid trials for all the subjects
  array[data_length] int<lower=0> subject_ids;           // subject id for each trial
  array[data_length] int<lower=1, upper=T> valid_trials; // valid trial numbers for each subject. (must be in ascending order)
  array[data_length] int<lower=0, upper=1> inputs;       // u. trial-by-trial binary sensory input (0 = orange, 1 = blue)
  array[data_length] int<lower=0, upper=1> responses;    // y. trial-by-trial binary response (0 = orange, 1 = blue)
}

transformed data {
  array[N] int<lower=1, upper=T> n_trials;               // total number of valid trials for each subject
  array[N] int<lower=0, upper=data_length> prev_trials;  // total number of trials for previous subjects in the raw data (for flattened x states)
  array[N, T] int<lower=0, upper=T> valid_trials_matrix; // only use 1 ~ valid_T[n] for each subject
  array[N, T] int<lower=0, upper=1> inputs_matrix;       // only use 1 ~ valid_T[n] for each subject
  array[N, T] int<lower=0, upper=1> responses_matrix;    // only use 1 ~ valid_T[n] for each subject
  matrix[N, T] time_variance;                            // only use 2 ~ valid_T[n] for each subject
  real NaN = -1e9;

  for (n in 1:N) {
    n_trials[n] = 0;
    prev_trials[n] = 0;
    for (t in 1:T) {
      valid_trials_matrix[n, t] = 0;
      inputs_matrix[n, t] = 0;
      responses_matrix[n, t] = 0;
      time_variance[n, t] = NaN;
    }
  }

  for (i in 1:data_length) {
    int subject_id = subject_ids[i];
    n_trials[subject_id] += 1;
    int trial_idx = n_trials[subject_id];
    valid_trials_matrix[subject_id, trial_idx] = valid_trials[i];
    inputs_matrix[subject_id, trial_idx] = inputs[i];
    responses_matrix[subject_id, trial_idx] = responses[i];
  }

  for (n in 2:N) {
    prev_trials[n] += prev_trials[n-1] + n_trials[n-1];
  }

  for (n in 1:N) {
    for (t in 2:T) {
      int cur = valid_trials_matrix[n, t];
      int prev = valid_trials_matrix[n, t - 1];
      int interval = cur - prev;
      if (interval > 0) {
        time_variance[n, t] = sqrt(interval);
      }
    }
  }
  real logit_parameter_sigma_upper = 3.0;
  real x_sigma_upper = 10.0;
  real kappa_upper = 2.0;
  real omega_bounds = 5.0;
  real theta_upper = 2.0;
  real zeta_upper = 3.0;
}

parameters {
  // States
  matrix<lower=-2, upper=2>[data_length, L-1] x_temp;
  matrix<lower=0, upper=x_sigma_upper>[N, L-1] x_sigma;

  // Group level
  real logit_kappa_mu;
  real logit_omega_mu;
  real logit_theta_mu;
  real logit_zeta_mu;

  real<lower=0, upper=logit_parameter_sigma_upper> logit_kappa_sigma;
  real<lower=0, upper=logit_parameter_sigma_upper> logit_omega_sigma;
  real<lower=0, upper=logit_parameter_sigma_upper> logit_theta_sigma;
  real<lower=0, upper=logit_parameter_sigma_upper> logit_zeta_sigma;

  // Individual level
  vector[N] logit_kappa_raw;
  vector[N] logit_omega_raw;
  vector[N] logit_theta_raw;
  vector[N] logit_zeta_raw;
}

transformed parameters {
  // non-centered parameterization
  vector[N] logit_kappa = logit_kappa_mu + logit_kappa_sigma * logit_kappa_raw;
  vector[N] logit_omega = logit_omega_mu + logit_omega_sigma * logit_omega_raw;
  vector[N] logit_theta = logit_theta_mu + logit_theta_sigma * logit_theta_raw;
  vector[N] logit_zeta = logit_zeta_mu + logit_zeta_sigma * logit_zeta_raw;

  // Perception model
  vector[N] kappa;
  vector[N] omega;
  vector[N] theta;

  real<lower=0, upper=kappa_upper> kappa_mu = inv_logit_with_bounds(logit_kappa_mu, 0, kappa_upper);
  kappa = inv_logit_with_bounds_vector(logit_kappa, 0, kappa_upper);

  real<lower=-omega_bounds, upper=omega_bounds> omega_mu = inv_logit_with_bounds(logit_omega_mu, -omega_bounds, omega_bounds);
  omega = inv_logit_with_bounds_vector(logit_omega, -omega_bounds, omega_bounds);

  real<lower=0, upper=theta_upper> theta_mu = inv_logit_with_bounds(logit_theta_mu, 0, theta_upper);
  theta = inv_logit_with_bounds_vector(logit_theta, 0, theta_upper);

  // Gaussian random walk with non-centered parameterization
  matrix[N, T] x2;
  matrix[N, T] x3;
  for (n in 1:N) {
    int cur_x_temp_trial = prev_trials[n];
    x2[n, 1] = x_sigma[n, 2-1] * x_temp[cur_x_temp_trial+1, 2-1];
    x3[n, 1] = x_sigma[n, 3-1] * x_temp[cur_x_temp_trial+1, 3-1];
    for (t in 2:n_trials[n]) {
      x3[n, t] = x3[n, t-1] + sqrt(theta[n]) * time_variance[n, t] * x_temp[cur_x_temp_trial+t, 3-1];
      real sigma = softplus((kappa[n] * x3[n, t] + omega[n])); 
      x2[n, t] = x2[n, t-1] + sigma * time_variance[n, t] * x_temp[cur_x_temp_trial+t, 2-1];
    }  
    for (t in n_trials[n]+1:T) {
      x2[n, t] = NaN;
      x3[n, t] = NaN;
    }
  }

  // Response model
  real<lower=0, upper=zeta_upper> zeta_mu;
  zeta_mu = inv_logit_with_bounds(logit_zeta_mu, 0, zeta_upper);
  vector[N] zeta;
  zeta = inv_logit_with_bounds_vector(logit_zeta, 0, zeta_upper);
}

model {
  // State
  to_vector(x_temp)     ~ normal(0, 1);
  to_vector(x_sigma)    ~ normal(x_sigma_upper/2, 1);

  // Group level
  logit_kappa_mu        ~ normal(0, 1);
  logit_omega_mu        ~ normal(0, 1);
  logit_theta_mu        ~ normal(0, 1);
  logit_zeta_mu         ~ normal(0, 1);

  logit_kappa_sigma     ~ normal(logit_parameter_sigma_upper/2, 1);
  logit_omega_sigma     ~ normal(logit_parameter_sigma_upper/2, 1);
  logit_theta_sigma     ~ normal(logit_parameter_sigma_upper/2, 1);
  logit_zeta_sigma      ~ normal(logit_parameter_sigma_upper/2, 1);

  // Individual level
  logit_kappa_raw       ~ normal(0, 1);
  logit_omega_raw       ~ normal(0, 1);
  logit_theta_raw       ~ normal(0, 1);
  logit_zeta_raw        ~ normal(0, 1);

  for (n in 1:N) {
    int max_T = n_trials[n];
    // Perception model
    inputs_matrix[n, 1:max_T] ~ bernoulli_logit(x2[n, 1:max_T]);

    // Response model
    vector[max_T-1] p = to_vector(inv_logit(zeta[n] * x2[n, 1:(max_T-1)]));
    responses_matrix[n, 2:max_T] ~ bernoulli(p);
  }
}

generated quantities {
  array[N, T, L] real x;
  for (n in 1:N) {
    for (t in 1:T) {
      for (l in 1:L) {
        x[n, t, l] = NaN;
      }
    }
    for (t in 1:n_trials[n]) {
      int trial_index = valid_trials_matrix[n, t];
      x[n, trial_index, 1] = inputs_matrix[n, t];
      x[n, trial_index, 2] = x2[n, t];
      x[n, trial_index, 3] = x3[n, t];
    }
  }
}
