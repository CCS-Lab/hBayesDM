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
  real mu0[L-1];
  real<lower=0> sigma0[L-1];

  // boundaries of parameters for each level
  real<lower=0> kappa_lower[L-2];
  real<lower=0> kappa_upper[L-2];
  real omega_lower[L-1];
  real omega_upper[L-1];
  real<lower=0> zeta_lower;
  real<lower=0> zeta_upper;
}

transformed data {
  real mu_base[L];
  real<lower=0> sigma_base[L];

  int<lower=0, upper=L-1> n_free_kappa = 0;
  int<lower=0, upper=L-2> free_kappa_idx[L-2] = rep_array(0,L-2);
  int<lower=0, upper=L-1> n_fixed_kappa = 0;
  int<lower=0, upper=L-2> fixed_kappa_idx[L-2] = rep_array(0,L-2);

  int<lower=0, upper=L-1> n_free_omega = 0;
  int<lower=0, upper=L-1> free_omega_idx[L-1] = rep_array(0,L-1);
  int<lower=0, upper=L-1> n_fixed_omega = 0;
  int<lower=0, upper=L-1> fixed_omega_idx[L-1] = rep_array(0,L-1);

  int<lower=0, upper=1> n_free_zeta = 1;

  mu_base[1] = 0;
  mu_base[2:L] = mu0;
  sigma_base[1] = 0;
  sigma_base[2:L] = sigma0;

  // differentiate free kappa and fixed kappa
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
  if (equal_with_threshold(zeta_lower, zeta_upper)) {
    n_free_zeta = 0;
  }
}

parameters {
  // logit of each parameter
  vector[n_free_kappa] logit_kappa;
  vector[n_free_omega] logit_omega; 
  vector[n_free_zeta] logit_zeta;
}

transformed parameters {
  vector[L-2] kappa;
  vector[L-1] omega;
  real<lower=zeta_lower, upper=zeta_upper> zeta;

  // Rebuild parameters with sampled values and fixed values
  if (n_free_kappa > 0) {
    for (i in 1:n_free_kappa) {
      int l = free_kappa_idx[i];
      kappa[l] = inv_logit_with_bounds(logit_kappa[i], kappa_lower[l], kappa_upper[l]);
    }
  }
  if (n_fixed_kappa > 0) {
    for (i in 1:n_fixed_kappa) {
      int l = fixed_kappa_idx[i];
      kappa[l] = kappa_lower[l];
    }
  }

  if (n_free_omega > 0) {
    for (i in 1:n_free_omega) {
      int l = free_omega_idx[i];
      omega[l] = inv_logit_with_bounds(logit_omega[i], omega_lower[l], omega_upper[l]);
    }
  }
  if (n_fixed_omega > 0) {
    for (i in 1:n_fixed_omega) {
      int l = fixed_omega_idx[i];
      omega[l] = omega_lower[l];
    }
  }

  if (n_free_zeta == 1) {
    zeta = inv_logit_with_bounds(logit_zeta[1], zeta_lower, zeta_upper);
  } else {
    zeta = zeta_lower;
  }
}

model {
  real mu[L] = mu_base;               // prediction (2 ~ L)
  real sa[L] = sigma_base;            // uncertainty of prediction (2 ~ L)
  real mu_hat[L] = rep_array(0.0, L); // prior prediction (1 ~ L)
  real sa_hat[L] = rep_array(0.0, L); // prior uncertainty of prediction (1 ~ L)
  real m = -1;                        // predictive probability that the next response will be 1 (0~1)

  // Priors
  to_vector(logit_kappa) ~ normal(0,10);
  to_vector(logit_omega) ~ normal(0,10);
  to_vector(logit_zeta)  ~ normal(0,10);

  for (t in 1:T) {
    real mu_prev;
    real pe;
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

    // Update prior uncertainty
    sa_hat[1] = mu_hat[1] * (1 - mu_hat[1]);
    for (l in 2:(L-1)) {
      real ka = kappa[l-1];
      real om = omega[l-1];
      sa_hat[l] = sa[l] + exp(ka * mu[l+1] + om);
    }
    sa_hat[L] = sa[L] + exp(omega[L-1]);

    // Level 2
    mu_prev = mu_hat[2];
    pe = u[t] - mu_hat[1];                       // prediction error
    sa[2] = 1.0 / ((1.0/sa_hat[2]) + sa_hat[1]); // learning rate
    mu[2] = mu_prev + sa[2] * pe;                // posterior prediction

    // Level 3 ~ L
    for (l in 3:L) {
      real ka = kappa[(l-1)-1];
      real om = omega[(l-1)-1];
      real mu_lower = mu[l-1];
      real mu_prev_ = mu_hat[l];
      real mu_prev_lower = mu_hat[l-1];
      real sa_lower = sa[l-1];
      real sa_prev_lower = sa_hat[l-1];

      real v = exp(ka * mu_prev_ + om); // volatility
      real w = v / sa_prev_lower;       // weighting factor (level: l-1)
      real vpe = ((sa_lower + pow(mu_lower - mu_prev_lower, 2)) / sa_prev_lower) - 1; // prediction error
      real r = 2*w - 1;                 // relative difference of environmental and informational uncertainty (level: l-1)
      real sa_ = 1.0/((1.0/sa_hat[l]) + 0.5 * pow(ka, 2) * w * (w + (r * vpe)));
      real lr = 0.5 * sa_ * ka * w;     // learning rate
      real pwpe = lr * vpe;             // precision-weighted prediction error
      mu[l] = mu_prev_ + pwpe;          // posterior prediction
      sa[l] = sa_;
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

  real mu[L] = mu_base;               // prediction (2 ~ L)
  real sa[L] = sigma_base;            // uncertainty of prediction (2 ~ L)
  real mu_hat[L] = rep_array(0.0, L); // prior prediction (1 ~ L)
  real sa_hat[L] = rep_array(0.0, L); // prior uncertainty of prediction (1 ~ L)
  real m = -1;                        // predictive probability that the next response will be 1 (0~1)

  for (t in 1:T) {
    real mu_prev;
    real pe;
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

    // Update prior uncertainty
    sa_hat[1] = mu_hat[1] * (1 - mu_hat[1]);
    for (l in 2:(L-1)) {
      real ka = kappa[l-1];
      real om = omega[l-1];
      sa_hat[l] = sa[l] + exp(ka * mu[l+1] + om);
    }
    sa_hat[L] = sa[L] + exp(omega[L-1]);

    // Level 2
    mu_prev = mu_hat[2];
    pe = u[t] - mu_hat[1];                       // prediction error
    sa[2] = 1.0 / ((1.0/sa_hat[2]) + sa_hat[1]); // learning rate
    mu[2] = mu_prev + sa[2] * pe;                // posterior prediction

    // Level 3 ~ L
    for (l in 3:L) {
      real ka = kappa[(l-1)-1];
      real om = omega[(l-1)-1];
      real mu_lower = mu[l-1];
      real mu_prev_ = mu_hat[l];
      real mu_prev_lower = mu_hat[l-1];
      real sa_lower = sa[l-1];
      real sa_prev_lower = sa_hat[l-1];

      real v = exp(ka * mu_prev_ + om); // volatility
      real w = v / sa_prev_lower;       // weighting factor (level: l-1)
      real vpe = ((sa_lower + pow(mu_lower - mu_prev_lower, 2)) / sa_prev_lower) - 1; // prediction error
      real r = 2*w - 1;                 // relative difference of environmental and informational uncertainty (level: l-1)
      real sa_ = 1.0/((1.0/sa_hat[l]) + 0.5 * pow(ka, 2) * w * (w + (r * vpe)));
      real lr = 0.5 * sa_ * ka * w;     // learning rate
      real pwpe = lr * vpe;             // precision-weighted prediction error
      mu[l] = mu_prev_ + pwpe;          // posterior prediction
      sa[l] = sa_;
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
