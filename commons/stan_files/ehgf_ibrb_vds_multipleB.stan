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
  int<lower=3> L;                    // maximum level of hierarchy

  int<lower=1> B;                    // maximum number of blocks across all participants
  int<lower=1> Bsubj[N];             // Number of blocks for each subject

  int<lower=1> T;                    // trials
  int<lower=0, upper=T> Tsubj[N,B];  // Number of trials for each block

  int<lower=-1,upper=1> u[N,B,T];    // inputs
  int<lower=-1,upper=1> y[N,B,T];    // responses (choices that subject made)
  int<lower=0, upper=1> input_first; // whether u[t] is observed before or after y[t]

  // starting point of belief and uncertainty on the first trial
  real mu0_lower[L-1];
  real mu0_upper[L-1];
  real<lower=0> sigma0[L-1];

  // boundaries of parameters for each level
  real<lower=0> kappa_lower[L-2];
  real<lower=0> kappa_upper[L-2];
  real omega_lower[L-1];
  real omega_upper[L-1];
}

transformed data {
  real<lower=0> sigma_base[L];
  int<lower=0, upper=L-1> n_free_mu0 = 0;
  int<lower=0, upper=L-1> free_mu0_idx[L-1] = rep_array(0,L-1);
  int<lower=0, upper=L-1> n_fixed_mu0 = 0;
  int<lower=0, upper=L-1> fixed_mu0_idx[L-1] = rep_array(0,L-1);

  int<lower=0, upper=L-1> n_free_kappa = 0;
  int<lower=0, upper=L-2> free_kappa_idx[L-2] = rep_array(0,L-2);
  int<lower=0, upper=L-1> n_fixed_kappa = 0;
  int<lower=0, upper=L-2> fixed_kappa_idx[L-2] = rep_array(0,L-2);

  int<lower=0, upper=L-1> n_free_omega = 0;
  int<lower=0, upper=L-1> free_omega_idx[L-1] = rep_array(0,L-1);
  int<lower=0, upper=L-1> n_fixed_omega = 0;
  int<lower=0, upper=L-1> fixed_omega_idx[L-1] = rep_array(0,L-1);

  int n_free_parameters;
  real mu1_min = 0.001;
  real mu1_max = 0.999;

  // differentiate free mu0 and fixed mu0
  for (l in 1:(L-1)) {
    if (equal_with_threshold(mu0_lower[l], mu0_upper[l])) {
      n_fixed_mu0 += 1;
      fixed_mu0_idx[n_fixed_mu0] = l;
    } else {
      n_free_mu0 += 1;
      free_mu0_idx[n_free_mu0] = l;
    }
  }
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

  n_free_parameters = n_free_mu0+n_free_kappa+n_free_omega;
}

parameters {
  // group-level raw parameters
  vector[n_free_parameters] mu_pr;
  vector<lower=0>[n_free_parameters] sigma;

  // subject-level raw parameters
  vector[N * n_free_mu0] mu0_pr;
  vector[N * n_free_kappa] kappa_pr;
  vector[N * n_free_omega] omega_pr;
}

transformed parameters {
  // group-level parameters
  vector[n_free_mu0] mu_mu0_pr;
  vector[n_free_kappa] mu_kappa_pr;
  vector[n_free_omega] mu_omega_pr;
  
  vector<lower=0>[n_free_mu0] mu0_sigma_pr;
  vector<lower=0>[n_free_kappa] kappa_sigma_pr;
  vector<lower=0>[n_free_omega] omega_sigma_pr;

  // subject-level parameters
  matrix[N,L-1] mu0;
  matrix[N,L-2] kappa;
  matrix[N,L-1] omega;

  if (n_free_mu0 > 0) {
    mu_mu0_pr = segment(mu_pr, 1, n_free_mu0);
    mu0_sigma_pr = segment(sigma, 1, n_free_mu0);
  }
  if (n_free_kappa > 0) {
    mu_kappa_pr = segment(mu_pr, 1+n_free_mu0, n_free_kappa);
    kappa_sigma_pr = segment(sigma, 1+n_free_mu0, n_free_kappa);
  }
  if (n_free_omega > 0) {
    mu_omega_pr = segment(mu_pr, 1+n_free_mu0+n_free_kappa, n_free_omega);
    omega_sigma_pr = segment(sigma, 1+n_free_mu0+n_free_kappa, n_free_omega);
  }

  // Rebuild parameters with sampled values and fixed values & Non-centered parameterization
  if (n_free_mu0 > 0) {
    for (i in 1:n_free_mu0) {
      int l = free_mu0_idx[i];
      vector[N] logit_mu0 = mu_mu0_pr[i] + mu0_sigma_pr[i] * segment(mu0_pr, 1+(i-1)*N, N);
      mu0[,l] = inv_logit_vector_with_bounds(logit_mu0, mu0_lower[l], mu0_upper[l]);
    }
  }
  if (n_fixed_mu0 > 0) {
    for (i in 1:n_fixed_mu0) {
      int l = fixed_mu0_idx[i];
      mu0[,l] = rep_vector(mu0_lower[l], N);
    }
  }

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
}

model {
  // Hyperparameters
  mu_pr ~ normal(0,1);
  sigma ~ normal(0,1);

  // individual parameters
  mu0_pr ~ normal(0,10);
  kappa_pr ~ normal(0,10);
  omega_pr ~ normal(0,10);
  
  // Subject loop
  for (i in 1:N) {
    for (bIdx in 1:Bsubj[i]) {
      row_vector[L-1] mu = mu0[i];        // prediction (2 ~ L)
      real sa[L] = sigma_base;            // uncertainty of prediction (2 ~ L)
      real mu_hat[L] = rep_array(0.0, L); // prior prediction (1 ~ L)
      real sa_hat[L] = rep_array(0.0, L); // prior uncertainty of prediction (1 ~ L)
      real eta = -1;                      // predictive probability that the next response will be 1 (0~1)

      // Trial loop
      for (t in 1:(Tsubj[i, bIdx])) {
        real mu_prev;
        real pe;
        // Filter invalid trials
        if (u[i,bIdx,t] == -1 || y[i,bIdx,t] == -1) {
          continue;
        }
        // Perception model
        // Update prior predictions
        for (l in 2:L) {
          mu_hat[l] = mu[l-1];
        }
        // Prediction
        mu_hat[1] = inv_logit(mu_hat[2]);
        mu_hat[1] = fmin(mu1_max, fmax(mu1_min, mu_hat[1]));

        // Update prior uncertainty
        sa_hat[1] = mu_hat[1] * (1 - mu_hat[1]);
        for (l in 2:(L-1)) {
          real ka = kappa[i,l-1];
          real om = omega[i,l-1];
          sa_hat[l] = sa[l] + exp(ka * mu[l] + om);
        }
        sa_hat[L] = sa[L] + exp(omega[i,L-1]);
    
        // Level 2
        mu_prev = mu_hat[2];
        pe = u[i,bIdx,t] - mu_hat[1];                     // prediction error
        sa[2] = 1.0 / ((1.0/sa_hat[2]) + sa_hat[1]); // learning rate
        mu[2-1] = mu_prev + sa[2] * pe;              // posterior prediction

        // Level 3 ~ L
        for (l in 3:L) {
          real ka = kappa[i,(l-1)-1];
          real om = omega[i,(l-1)-1];
          real mu_lower = mu[l-1-1];
          real mu_prev_ = mu_hat[l];
          real mu_prev_lower = mu_hat[l-1];
          real sa_lower = sa[l-1];
          real sa_prev_lower = sa_hat[l-1];
          real vv, pimhat, ww, rr, dd;

          real v = exp(ka * mu_prev_ + om); // volatility
          real w = v / sa_prev_lower;       // weighting factor (level: l-1)
        
          real vpe = ((sa_lower + pow(mu_lower - mu_prev_lower, 2)) / sa_prev_lower) - 1; // volatility prediction error
          real lr = 0.5 * sa_hat[l] * ka * w; // learning rate
          real pwpe = lr * vpe;             // precision-weighted prediction error
          mu[l-1] = mu_prev_ + pwpe;        // posterior prediction

          vv = exp(ka * mu[l-1] +om);
          pimhat = 1.0 / (sa_prev_lower +vv);
          ww = vv * pimhat;
          rr = (vv - sa_prev_lower) * pimhat;
          dd = (sa_lower + square(mu_lower - mu_prev_lower)) *pimhat - 1;

          sa[l] = 1.0/((1.0/sa_hat[l]) + fmax(0.0, 0.5 * square(ka) * ww * (ww + rr * dd)));
        }

        // Response model (volatility-dependent stochasticity)
        if (input_first) {
          // make choice based on current input
          eta = exp(-mu_hat[3]) * mu_hat[2]; // zeta = exp(-mu_hat[3])
          y[i,bIdx,t] ~ bernoulli_logit(eta);
        } else if (eta >= 0) {
          // make choice based on previous valid input
          y[i,bIdx,t] ~ bernoulli_logit(eta);
        }
        eta = exp(-mu_hat[3]) * mu_hat[2];
      }
    }
  }
}

generated quantities {
  real log_lik = 0;

  vector[L-1] mu_mu0;
  vector[L-2] mu_kappa;
  vector[L-1] mu_omega;
  
    // Subject loop
  for (i in 1:N) {
    for (bIdx in 1:Bsubj[i]) {
      row_vector[L-1] mu = mu0[i];        // prediction (2 ~ L)
      real sa[L] = sigma_base;            // uncertainty of prediction (2 ~ L)
      real mu_hat[L] = rep_array(0.0, L); // prior prediction (1 ~ L)
      real sa_hat[L] = rep_array(0.0, L); // prior uncertainty of prediction (1 ~ L)
      real eta = -1;                      // predictive probability that the next response will be 1 (0~1)

      // Trial loop
      for (t in 1:(Tsubj[i, bIdx])) {
        real mu_prev;
        real pe;
        // Filter invalid trials
        if (u[i,bIdx,t] == -1 || y[i,bIdx,t] == -1) {
          continue;
        }
        // Perception model
        // Update prior predictions
        for (l in 2:L) {
          mu_hat[l] = mu[l-1];
        }
        // Prediction
        mu_hat[1] = inv_logit(mu_hat[2]);
        mu_hat[1] = fmin(mu1_max, fmax(mu1_min, mu_hat[1]));

        // Update prior uncertainty
        sa_hat[1] = mu_hat[1] * (1 - mu_hat[1]);
        for (l in 2:(L-1)) {
          real ka = kappa[i,l-1];
          real om = omega[i,l-1];
          sa_hat[l] = sa[l] + exp(ka * mu[l+1-1] + om);
        }
        sa_hat[L] = sa[L] + exp(omega[i,L-1]);
    
        // Level 2
        mu_prev = mu_hat[2];
        pe = u[i,bIdx,t] - mu_hat[1];                     // prediction error
        sa[2] = 1.0 / ((1.0/sa_hat[2]) + sa_hat[1]); // learning rate
        mu[2-1] = mu_prev + sa[2] * pe;              // posterior prediction

        // Level 3 ~ L
        for (l in 3:L) {
          real ka = kappa[i,(l-1)-1];
          real om = omega[i,(l-1)-1];
          real mu_lower = mu[l-1-1];
          real mu_prev_ = mu_hat[l];
          real mu_prev_lower = mu_hat[l-1];
          real sa_lower = sa[l-1];
          real sa_prev_lower = sa_hat[l-1];
          real vv, pimhat, ww, rr, dd;

          real v = exp(ka * mu_prev_ + om);// volatility
          real w = v / sa_prev_lower;      // weighting factor (level: l-1)

          real vpe = ((sa_lower + pow(mu_lower - mu_prev_lower, 2)) / sa_prev_lower) - 1; // volatility prediction error
          real lr = 0.5 * sa_hat[l] * ka * w; // learning rate
          real pwpe = lr * vpe;             // precision-weighted prediction error
          mu[l-1] = mu_prev_ + pwpe;        // posterior prediction

          vv = exp(ka * mu[l-1] +om);
          pimhat = 1.0 / (sa_prev_lower +vv);
          ww = vv * pimhat;
          rr = (vv - sa_prev_lower) * pimhat;
          dd = (sa_lower + square(mu_lower - mu_prev_lower)) *pimhat - 1;

          sa[l] = 1.0/((1.0/sa_hat[l]) + fmax(0.0, 0.5 * square(ka) * ww * (ww + rr * dd)));
        }

        // Response model (volatility-dependent stochasticity)
        if (input_first) {
          // make choice based on current input
          eta = exp(-mu_hat[3]) * mu_hat[2]; // zeta = exp(-mu_hat[3])
          log_lik += bernoulli_logit_lpmf(y[i,bIdx,t] | eta);
        } else if (eta >= 0) {
          // make choice based on previous valid input
          log_lik += bernoulli_logit_lpmf(y[i,bIdx,t] | eta);
        }
        eta = exp(-mu_hat[3]) * mu_hat[2];
      }
    }
  }

  for (i in 1:n_free_mu0) {
    int l = free_mu0_idx[i];
    mu_mu0[l] = inv_logit_with_bounds(mu_mu0_pr[i], mu0_lower[l], mu0_upper[l]);
  }
  for (i in 1:n_fixed_mu0) {
    int l = fixed_mu0_idx[i];
    mu_mu0[l] = mu0_lower[l];
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
}
