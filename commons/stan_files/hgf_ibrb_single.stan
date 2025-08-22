#include /pre/license.stan

// Hierarchical Gaussian Filter from Mathys et al. (2011) https://doi.org/10.3389/fnhum.2011.00039

functions {
  real inv_logit_with_bounds(real x, real a, real b) {
    return a + (b - a) * inv_logit(x);
  }

  int equal_with_threshold(real a, real b) {
    return abs(a - b) < 1e-12;
  }
}

data {
  int<lower=1> T;                    // trials
  int<lower=3> L;                    // maximum level of hierarchy
  int<lower=-1,upper=1> u[T];        // inputs
  int<lower=-1,upper=1> y[T];        // responses (choices that subject made)
  int<lower=0, upper=1> input_first; // whether input is observed after response

  // starting point of belief and uncertainty on the first trial
  array[L-1] real mu0;
  array[L-1] real sigma0;

  // boundaries of parameters for each level
  array[L-2] real<lower=0> kappa_lower;
  array[L-2] real<lower=0> kappa_upper;
  array[L-1] real omega_lower;
  array[L-1] real omega_upper;
  real<lower=0> zeta_lower;
  real<lower=0> zeta_upper;
}

transformed data {
  array[L] real mu_base;
  mu_base[1] = 0;
  mu_base[2:L] = mu0;
  array[L] real sigma_base;
  sigma_base[1] = 0;
  sigma_base[2:L] = sigma0;

  // differentiate free kappa and fixed kappa
  int<lower=0, upper=L-1> n_free_kappa = 0;
  array[L-2] int<lower=0, upper=L-2> free_kappa_idx = rep_array(0,L-2);
  int<lower=0, upper=L-1> n_fixed_kappa = 0;
  array[L-2] int<lower=0, upper=L-2> fixed_kappa_idx = rep_array(0,L-2);
  for (l in 1:(L-2)) {
    if (equal_with_threshold(kappa_lower[l], kappa_upper[l])) {
      n_fixed_kappa += 1;
      fixed_kappa_idx[n_fixed_kappa] = l;
    } else {
      n_free_kappa += 1;
      free_kappa_idx[n_free_kappa] = l;
    }
  }

  // differentiate free omega and fixed omega
  int<lower=0, upper=L-1> n_free_omega = 0;
  array[L-1] int<lower=0, upper=L-1> free_omega_idx = rep_array(0,L-1);
  int<lower=0, upper=L-1> n_fixed_omega = 0;
  array[L-1] int<lower=0, upper=L-1> fixed_omega_idx = rep_array(0,L-1);
  for (l in 1:(L-1)) {
    if (equal_with_threshold(omega_lower[l], omega_upper[l])) {
      n_fixed_omega += 1;
      fixed_omega_idx[n_fixed_omega] = l;
    } else {
      n_free_omega += 1;
      free_omega_idx[n_free_omega] = l;
    }
  }

  // check whether zeta is fixed
  int<lower=0, upper=1> n_free_zeta = 1;
  if (equal_with_threshold(zeta_lower, zeta_upper)) {
    n_free_zeta = 0;
  }
}

parameters {
  vector[n_free_kappa] logit_kappa;
  vector[n_free_omega] logit_omega; 
  vector[n_free_zeta] logit_zeta;
}

transformed parameters {
  vector[L-2] kappa;
  vector[L-1] omega;
  real<lower=zeta_lower, upper=zeta_upper> zeta;

  // Rebuild parameters with sampled values and fixed values
  for (i in 1:n_free_kappa) {
    int l = free_kappa_idx[i];
    kappa[l] = inv_logit_with_bounds(logit_kappa[i], kappa_lower[l], kappa_upper[l]);
  }
  for (i in 1:n_fixed_kappa) {
    int l = fixed_kappa_idx[i];
    kappa[l] = kappa_lower[l];
  }

  for (i in 1:n_free_omega) {
    int l = free_omega_idx[i];
    omega[l] = inv_logit_with_bounds(logit_omega[i], omega_lower[l], omega_upper[l]);
  }
  for (i in 1:n_fixed_omega) {
    int l = fixed_omega_idx[i];
    omega[l] = omega_lower[l];
  }

  if (n_free_zeta == 1) {
    zeta = inv_logit_with_bounds(logit_zeta[1], zeta_lower, zeta_upper);
  } else {
    zeta = zeta_lower;
  }
}

model {
  // Priors
  to_vector(logit_kappa) ~ normal(0,10);
  to_vector(logit_omega) ~ normal(0,10);
  to_vector(logit_zeta)  ~ normal(0,10);

  array[L] real mu = mu_base;                // prediction (2 ~ L)
  array[L] real sigma = sigma_base;          // upcertainty of prediction (2 ~ L)
  array[L] real mu_hat = rep_array(0, L);    // prior prediction (1 ~ L)
  array[L] real sigma_hat = rep_array(0, L); // prior upcertainty of prediction (1 ~ L)
  real m = -1;                               // predictive probability that the next response will be 1 (0~1)

  for (t in 1:T) {
    // Filter invalid trials
    if (u[t] == -1 || y[t] == -1) {
      continue;
    }
    // Perception model
    // Update prior predictions
    for (l in 2:L) {
      mu_hat[l] = mu[l];
    }
    // Prediction
    mu_hat[1] = inv_logit(mu_hat[2]);

    // Update prior upcertainty
    sigma_hat[1] = mu_hat[1] * (1 - mu_hat[1]);
    for (l in 2:(L-1)) {
      real ka = kappa[l-1];
      real om = omega[l-1];
      sigma_hat[l] = sigma[l] + exp(ka * mu[l+1] + om);
    }
    sigma_hat[L] = sigma[L] + exp(omega[L-1]);

    // Level 2
    real mu_prev = mu_hat[2];
    real pe = u[t] - mu_hat[1];                           // prediction error
    sigma[2] = 1.0 / ((1.0/sigma_hat[2]) + sigma_hat[1]); // learning rate
    mu[2] = mu_prev + sigma[2] * pe;                      // posterior prediction

    // Level 3 ~ L
    for (l in 3:L) {
      real ka = kappa[(l-1)-1];
      real om = omega[(l-1)-1];
      real mu_lower = mu[l-1];
      mu_prev = mu_hat[l];
      real mu_prev_lower = mu_hat[l-1];
      real sigma_lower = sigma[l-1];
      real sigma_prev_lower = sigma_hat[l-1];

      real v = exp(ka * mu_prev + om); // volatility
      real w = v / sigma_prev_lower;                   // weighting factor (level: l-1)
      real vpe = ((sigma_lower + pow(mu_lower - mu_prev_lower, 2)) / sigma_prev_lower) - 1; // prediction error
      real r = 2*w - 1;                                // relative difference of environmental and informational uncertainty (level: l-1)
      sigma[l] = 1.0/((1.0/sigma_hat[l]) + 0.5 * pow(ka, 2) * w * (w + (r * vpe)));
      real lr = 0.5 * sigma[l] * ka * w;               // learning rate
      real pwpe = lr * vpe;                            // precision-weighted prediction error
      mu[l] = mu_prev + pwpe;                          // posterior prediction
    }

    // Response model (unit-square sigmoid)
    if (input_first) {
      // make choice based on current input
      y[t] ~ bernoulli_logit(zeta * logit(mu_hat[1]));
    } else if (m >= 0) {
      // make choice based on previous valid input
      y[t] ~ bernoulli_logit(zeta * logit(m));
    }
    m = mu_hat[1];
  }
}

generated quantities {
  real log_lik = 0;

  array[L] real mu = mu_base;                // prediction (2 ~ L)
  array[L] real sigma = sigma_base;          // upcertainty of prediction (2 ~ L)
  array[L] real mu_hat = rep_array(0, L);    // prior prediction (1 ~ L)
  array[L] real sigma_hat = rep_array(0, L); // prior upcertainty of prediction (1 ~ L)
  real m = -1;                               // predictive probability that the next response will be 1 (0~1)

  for (t in 1:T) {
    // Filter invalid trials
    if (u[t] == -1 || y[t] == -1) {
      continue;
    }
    // Perception model
    // Update prior predictions
    for (l in 2:L) {
      mu_hat[l] = mu[l];
    }
    // Prediction
    mu_hat[1] = inv_logit(mu_hat[2]);

    // Update prior upcertainty
    sigma_hat[1] = mu_hat[1] * (1 - mu_hat[1]);
    for (l in 2:(L-1)) {
      real ka = kappa[l-1];
      real om = omega[l-1];
      sigma_hat[l] = sigma[l] + exp(ka * mu[l+1] + om);
    }
    sigma_hat[L] = sigma[L] + exp(omega[L-1]);

    // Level 2
    real mu_prev = mu_hat[2];
    real pe = u[t] - mu_hat[1];                           // prediction error
    sigma[2] = 1.0 / ((1.0/sigma_hat[2]) + sigma_hat[1]); // learning rate
    mu[2] = mu_prev + sigma[2] * pe;                      // posterior prediction

    // Level 3 ~ L
    for (l in 3:L) {
      real ka = kappa[(l-1)-1];
      real om = omega[(l-1)-1];
      real mu_lower = mu[l-1];
      mu_prev = mu_hat[l];
      real mu_prev_lower = mu_hat[l-1];
      real sigma_lower = sigma[l-1];
      real sigma_prev_lower = sigma_hat[l-1];

      real v = exp(ka * mu_prev + om); // volatility
      real w = v / sigma_prev_lower;                   // weighting factor (level: l-1)
      real vpe = ((sigma_lower + pow(mu_lower - mu_prev_lower, 2)) / sigma_prev_lower) - 1; // prediction error
      real r = 2*w - 1;                                // relative difference of environmental and informational uncertainty (level: l-1)
      sigma[l] = 1.0/((1.0/sigma_hat[l]) + 0.5 * pow(ka, 2) * w * (w + (r * vpe)));
      real lr = 0.5 * sigma[l] * ka * w;               // learning rate
      real pwpe = lr * vpe;                            // precision-weighted prediction error
      mu[l] = mu_prev + pwpe;                          // posterior prediction
    }

    // Response model (unit-square sigmoid)
    if (input_first) {
      // make choice based on current input
      log_lik += bernoulli_logit_lpmf(y[t] | zeta * logit(mu_hat[1]));
    } else if (m >= 0) {
      // make choice based on previous valid input
      log_lik += bernoulli_logit_lpmf(y[t] | zeta * logit(m));
    }
    m = mu_hat[1];
  }
}
