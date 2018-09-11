data {
  int<lower=1> N;            // Number of subjects
  int<lower=1> T;            // Maximum number of trials
  int<lower=0> Tsubj[N];     // Number of trials for each subject
  int<lower=2> P;            // Number of max pump + 1 ** CAUTION **
  int<lower=0> pumps[N, T];  // Number of pump
  int<lower=0,upper=1> explosion[N, T];  // Whether the balloon exploded (0 or 1)
}

transformed data{
  // Whether a subject pump the button or not (0 or 1)
  int d[N, T, P];

  for (j in 1:N) {
    for (k in 1:Tsubj[j]) {
      for (l in 1:P) {
        if (l <= pumps[j, k])
          d[j, k, l] = 1;
        else
          d[j, k, l] = 0;
      }
    }
  }
}

parameters {
  // Group-level parameters
  vector[4] mu_p;
  vector<lower=0>[4] sigma;

  // Normally distributed error for Matt trick
  vector[N] phi_p;
  vector[N] eta_p;
  vector[N] gam_p;
  vector[N] tau_p;
}

transformed parameters {
  // Subject-level parameters with Matt trick
  vector<lower=0,upper=1>[N] phi;
  vector<lower=0>[N] eta;
  vector<lower=0>[N] gam;
  vector<lower=0>[N] tau;

  phi = Phi_approx(mu_p[1] + sigma[1] * phi_p);
  eta = exp(mu_p[2] + sigma[2] * eta_p);
  gam = exp(mu_p[3] + sigma[3] * gam_p);
  tau = exp(mu_p[4] + sigma[4] * tau_p);
}

model {
  // Prior
  mu_p  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  phi_p ~ normal(0, 1);
  eta_p ~ normal(0, 1);
  gam_p ~ normal(0, 1);
  tau_p ~ normal(0, 1);

  // Likelihood
  for (j in 1:N) {
    // Initialize n_succ and n_pump for a subject
    int n_succ = 0;  // Number of successful pumps
    int n_pump = 0;  // Number of total pumps

    for (k in 1:Tsubj[j]) {
      real p_burst;  // Belief on a balloon to be burst
      real omega;    // Optimal number of pumps

      p_burst = 1 - ((phi[j] + eta[j] * n_succ) / (1 + eta[j] * n_pump));
      omega = -gam[j] / log1m(p_burst);

      // Calculate likelihood with bernoulli distribution
      for (l in 1:(pumps[j, k] + 1 - explosion[j, k]))
        d[j, k, l] ~ bernoulli_logit(tau[j] * (omega - l));

      // Update n_succ and n_pump after each trial ends
      n_succ += pumps[j, k] - explosion[j, k];
      n_pump += pumps[j, k];
    }
  }
}

generated quantities {
  // Actual group-level mean
  real<lower=0> mu_phi = Phi_approx(mu_p[1]);
  real<lower=0> mu_eta = exp(mu_p[2]);
  real<lower=0> mu_gam = exp(mu_p[3]);
  real<lower=0> mu_tau = exp(mu_p[4]);

  // Log-likelihood for model fit
  real log_lik = 0;

  // For posterior predictive check
  real y_pred[N, T, P];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (j in 1:N)
    for (k in 1:T)
      for(l in 1:P)
        y_pred[j, k, l] = -1;

  { // Local section to save time and space
    for (j in 1:N) {
      int n_succ = 0;
      int n_pump = 0;

      for (k in 1:Tsubj[j]) {
        real p_burst;  // Belief on a balloon to be burst
        real omega;    // Optimal number of pumps

        p_burst = 1 - ((phi[j] + eta[j] * n_succ) / (1 + eta[j] * n_pump));
        omega = -gam[j] / log1m(p_burst);

        for (l in 1:(pumps[j, k] + 1 - explosion[j, k])) {
          log_lik += bernoulli_logit_lpmf(d[j, k, l] | tau[j] * (omega - l));
          y_pred[j, k, l] = bernoulli_logit_rng(tau[j] * (omega - l));
        }

        n_succ += pumps[j, k] - explosion[j, k];
        n_pump += pumps[j, k];
      }
    }
  }
}
