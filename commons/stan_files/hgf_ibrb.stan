#include /pre/license.stan

// Hierarchical Gaussian Filter from Mathys et al. (2011) https://doi.org/10.3389/fnhum.2011.00039

functions {
  real inv_logit_with_bounds(real x, real a, real b) {
    return a + (b - a) * inv_logit(x);
  }

  vector inv_logit_vector_with_bounds(vector x, real a, real b) {
    return a + (b - a) * inv_logit(x);
  }

  int equal_with_threshold(real a, real b) {
    return abs(a - b) < 1e-12;
  }
}

data {
  int<lower=1> N;                    // subjects
  int<lower=1> T;                    // trials
  int<lower=3> L;                    // maximum level of hierarchy
  int<lower=-1,upper=1> u[N,T];      // inputs
  int<lower=-1,upper=1> y[N,T];      // responses (choices that subject made)
  int<lower=0, upper=1> input_first; // whether u[t] is observed before or after y[t]

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

  int n_free_parameters;

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

  n_free_parameters = n_free_kappa+n_free_omega+n_free_zeta;
}

parameters {
  // group-level raw parameters
  vector[n_free_parameters] mu_pr;
  vector<lower=0>[n_free_parameters] sigma;

  // subject-level raw parameters
  vector[N * n_free_kappa] kappa_pr;
  vector[N * n_free_omega] omega_pr;
  vector[N * n_free_zeta] zeta_pr;
}

transformed parameters {
  // group-level parameters
  vector[n_free_kappa] mu_kappa_pr;
  vector[n_free_omega] mu_omega_pr;
  vector[n_free_zeta] mu_zeta_pr;
  
  vector<lower=0>[n_free_kappa] kappa_sigma_pr;
  vector<lower=0>[n_free_omega] omega_sigma_pr;
  vector<lower=0>[n_free_zeta] zeta_sigma_pr;

  // subject-level parameters
  matrix[N,L-2] kappa;
  matrix[N,L-1] omega;
  vector[N] zeta;

  if (n_free_kappa > 0) {
    mu_kappa_pr = segment(mu_pr, 1, n_free_kappa);
    kappa_sigma_pr = segment(sigma, 1, n_free_kappa);
  }
  if (n_free_omega > 0) {
    mu_omega_pr = segment(mu_pr, 1+n_free_kappa, n_free_omega);
    omega_sigma_pr = segment(sigma, 1+n_free_kappa, n_free_omega);
  }
  if (n_free_zeta == 1) {
    mu_zeta_pr = segment(mu_pr, 1+n_free_kappa+n_free_omega, n_free_zeta);
    zeta_sigma_pr = segment(sigma, 1+n_free_kappa+n_free_omega, n_free_zeta);
  }

  // Rebuild parameters with sampled values and fixed values & Non-centered parameterization
  if (n_free_kappa > 0) {
    for (i in 1:n_free_kappa) {
      int l = free_kappa_idx[i];
      vector[N] logit_kappa = mu_kappa_pr[i] + kappa_sigma_pr[i] * segment(kappa_pr, 1+(i-1)*N, N);
      kappa[,l] = inv_logit_vector_with_bounds(logit_kappa, kappa_lower[l], kappa_upper[l]);
    }
  }
  if (n_fixed_kappa > 0) {
    for (i in 1:n_fixed_kappa) {
      int l = fixed_kappa_idx[i];
      kappa[,l] = rep_vector(kappa_lower[l], N);
    }
  }

  if (n_free_omega > 0) {
    for (i in 1:n_free_omega) {
      int l = free_omega_idx[i];
      vector[N] logit_omega = mu_omega_pr[i] + omega_sigma_pr[i] * segment(omega_pr, 1+(i-1)*N, N);
      omega[,l] = inv_logit_vector_with_bounds(logit_omega, omega_lower[l], omega_upper[l]);
    }
  }
  if (n_fixed_omega > 0) {
    for (i in 1:n_fixed_omega) {
      int l = fixed_omega_idx[i];
      omega[,l] = rep_vector(omega_lower[l], N);
    }
  }

  if (n_free_zeta == 1) {
    vector[N] logit_zeta = mu_zeta_pr[1] + zeta_sigma_pr[1] * segment(zeta_pr, 1, N);
    zeta = inv_logit_vector_with_bounds(logit_zeta, zeta_lower, zeta_upper);
  } else {
    zeta = rep_vector(zeta_lower, N);
  }
}

model {
  // Hyperparameters
  mu_pr ~ normal(0,1);
  sigma ~ normal(0,1);

  // individual parameters
  kappa_pr ~ normal(0,10);
  omega_pr ~ normal(0,10);
  zeta_pr ~ normal(0,10);
  
  // Subject loop
  for (i in 1:N) {
    real mu[L] = mu_base;               // prediction (2 ~ L)
    real sa[L] = sigma_base;            // uncertainty of prediction (2 ~ L)
    real mu_hat[L] = rep_array(0.0, L); // prior prediction (1 ~ L)
    real sa_hat[L] = rep_array(0.0, L); // prior uncertainty of prediction (1 ~ L)
    real m = -1;                        // predictive probability that the next response will be 1 (0~1)

    // Trial loop
    for (t in 1:T) {
      real mu_prev;
      real pe;
      // Filter invalid trials
      if (u[i,t] == -1 || y[i,t] == -1) {
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
        real ka = kappa[i,l-1];
        real om = omega[i,l-1];
        sa_hat[l] = sa[l] + exp(ka * mu[l+1] + om);
      }
      sa_hat[L] = sa[L] + exp(omega[i,L-1]);
  
      // Level 2
      mu_prev = mu_hat[2];
      pe = u[i,t] - mu_hat[1];                     // prediction error
      sa[2] = 1.0 / ((1.0/sa_hat[2]) + sa_hat[1]); // learning rate
      mu[2] = mu_prev + sa[2] * pe;                // posterior prediction

      // Level 3 ~ L
      for (l in 3:L) {
        real ka = kappa[i,(l-1)-1];
        real om = omega[i,(l-1)-1];
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
        y[i,t] ~ bernoulli_logit(zeta[i] * logit(mu_hat[1]));
      } else if (m >= 0) {
        // make choice based on previous valid input
        y[i,t] ~ bernoulli_logit(zeta[i] * logit(m));
      }
      m = mu_hat[1];
    }
  }
}

generated quantities {
  real log_lik = 0;

  vector[L-2] mu_kappa;
  vector[L-1] mu_omega;
  real<lower=0> mu_zeta;
  
    // Subject loop
  for (i in 1:N) {
    real mu[L] = mu_base;               // prediction (2 ~ L)
    real sa[L] = sigma_base;            // uncertainty of prediction (2 ~ L)
    real mu_hat[L] = rep_array(0.0, L); // prior prediction (1 ~ L)
    real sa_hat[L] = rep_array(0.0, L); // prior uncertainty of prediction (1 ~ L)
    real m = -1;                        // predictive probability that the next response will be 1 (0~1)

    // Trial loop
    for (t in 1:T) {
      real mu_prev;
      real pe;
      // Filter invalid trials
      if (u[i,t] == -1 || y[i,t] == -1) {
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
        real ka = kappa[i,l-1];
        real om = omega[i,l-1];
        sa_hat[l] = sa[l] + exp(ka * mu[l+1] + om);
      }
      sa_hat[L] = sa[L] + exp(omega[i,L-1]);
  
      // Level 2
      mu_prev = mu_hat[2];
      pe = u[i,t] - mu_hat[1];                     // prediction error
      sa[2] = 1.0 / ((1.0/sa_hat[2]) + sa_hat[1]); // learning rate
      mu[2] = mu_prev + sa[2] * pe;                // posterior prediction

      // Level 3 ~ L
      for (l in 3:L) {
        real ka = kappa[i,(l-1)-1];
        real om = omega[i,(l-1)-1];
        real mu_lower = mu[l-1];
        real mu_prev_ = mu_hat[l];
        real mu_prev_lower = mu_hat[l-1];
        real sa_lower = sa[l-1];
        real sa_prev_lower = sa_hat[l-1];

        real v = exp(ka * mu_prev_ + om);// volatility
        real w = v / sa_prev_lower;      // weighting factor (level: l-1)
        real vpe = ((sa_lower + pow(mu_lower - mu_prev_lower, 2)) / sa_prev_lower) - 1; // prediction error
        real r = 2*w - 1;                // relative difference of environmental and informational uncertainty (level: l-1)
        real sa_ = 1.0/((1.0/sa_hat[l]) + 0.5 * pow(ka, 2) * w * (w + (r * vpe)));
        real lr = 0.5 * sa_ * ka * w;    // learning rate
        real pwpe = lr * vpe;            // precision-weighted prediction error
        mu[l] = mu_prev_ + pwpe;         // posterior prediction
        sa[l] = sa_;
      }

      // Response model (unit-square sigmoid)
      if (input_first) {
        // make choice based on current input
        log_lik += bernoulli_logit_lpmf(y[i,t] | zeta[i] * logit(mu_hat[1]));
      } else if (m >= 0) {
        // make choice based on previous valid input
        log_lik += bernoulli_logit_lpmf(y[i,t] | zeta[i] * logit(m));
      }
      m = mu_hat[1];
    }
  }

  for (i in 1:n_free_kappa) {
    int l = free_kappa_idx[i];
    mu_kappa[l] = inv_logit_with_bounds(mu_kappa_pr[i], kappa_lower[l], kappa_upper[l]);
  }
  for (i in 1:n_fixed_kappa) {
    int l = fixed_kappa_idx[i];
    mu_kappa[l] = kappa_lower[l];
  }

  for (i in 1:n_free_omega) {
    int l = free_omega_idx[i];
    mu_omega[l] = inv_logit_with_bounds(mu_omega_pr[i], omega_lower[l], omega_upper[l]);
  }
  for (i in 1:n_fixed_omega) {
    int l = fixed_omega_idx[i];
    mu_omega[l] = omega_lower[l];
  }

  if (n_free_zeta == 1) {
    mu_zeta = inv_logit_with_bounds(mu_zeta_pr[1], zeta_lower, zeta_upper);
  } else {
    mu_zeta = zeta_lower;
  }
}
