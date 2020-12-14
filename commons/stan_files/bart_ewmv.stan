data {
  int<lower=1> N;             // Number of subjects
  int<lower=1> T;             // Maximum number of trials
  int<lower=0> Tsubj[N];      // Number of trials for each subject
  int<lower=2> P;             // Number of max pump + 1 ** CAUTION **
  int<lower=0> pumps[N, T];   // Number of pump
  // int<lower=0> reward[N, T];  // Amount of rewards
  int<lower=0,upper=1> explosion[N, T];  // Whether the balloon exploded (0 or 1)
}

transformed data {
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
  vector[5] mu_p;
  vector<lower=0>[5] sigma;

  // Normally distributed error for Matt trick
  vector[N] phi_p;
  vector[N] eta_p;
  vector[N] rho_p;
  vector[N] tau_p;
  vector[N] lambda_p;
}

transformed parameters {
  // Subject-level parameters with Matt trick
  vector<lower=0,upper=1>[N] phi;
  vector<lower=0>[N] eta;
  vector<lower=-0.5,upper=0.5>[N] rho;
  vector<lower=0>[N] tau;
  vector<lower=0>[N] lambda;

  phi = Phi_approx(mu_p[1] + sigma[1] * phi_p);
  eta = Phi_approx(mu_p[2] + sigma[2] * eta_p);
  rho = 0.5 - Phi_approx(mu_p[3] + sigma[3] * rho_p);
  tau = exp(mu_p[4] + sigma[4] * tau_p);
  lambda = exp(mu_p[5] + sigma[5] * lambda_p);
}

model {
  // Prior
  mu_p  ~ normal(0, 1);
  sigma ~ normal(0, 0.2); // cauchy(0, 5);

  phi_p ~ normal(0, 1);
  eta_p ~ normal(0, 1);
  rho_p ~ normal(0, 1);
  tau_p ~ normal(0, 1);
  lambda_p ~ normal(0, 1);

  // Likelihood
  for (j in 1:N) {
    // Initialize n_succ and n_pump for a subject
    int n_succ = 0;  // Number of successful pumps
    int n_pump = 0;  // Number of total pumps
    real p_burst = phi[j];

    for (k in 1:Tsubj[j]) {
      real u_gain = 1;
      real u_loss;
      real u_pump;
      real u_stop = 0;
      real delta_u;

      for (l in 1:(pumps[j, k] + 1 - explosion[j, k])) {
        u_loss = (l - 1);

        u_pump = (1 - p_burst) * u_gain - lambda[j] * p_burst * u_loss +
        rho[j] * p_burst * (1 - p_burst) * (u_gain + lambda[j] * u_loss)^2;
        // u_stop always equals 0.

        delta_u = u_pump - u_stop;

        // Calculate likelihood with bernoulli distribution
        d[j, k, l] ~ bernoulli_logit(tau[j] * delta_u);
      }

      // Update n_succ and n_pump after each trial ends
      n_succ += pumps[j, k] - explosion[j, k];
      n_pump += pumps[j, k];

      p_burst = phi[j] + (1 - exp(-n_pump * eta[j])) * ((0.0 + n_pump - n_succ) / n_pump - phi[j]);
    }
  }
}

generated quantities {
  // Actual group-level mean
  real<lower=0> mu_phi = Phi_approx(mu_p[1]);
  real<lower=0> mu_eta = Phi_approx(mu_p[2]);
  real<lower=-0.5,upper=0.5> mu_rho = 0.5 - Phi_approx(mu_p[3]);
  real<lower=0> mu_tau = exp(mu_p[4]);
  real<lower=0> mu_lambda = exp(mu_p[5]);

  // Log-likelihood for model fit
  real log_lik[N];

  // For posterior predictive check
  real y_pred[N, T, P];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (j in 1:N)
    for (k in 1:T)
      for(l in 1:P)
        y_pred[j, k, l] = -1;

  { // Local section to save time and space
    for (j in 1:N) {
      // Initialize n_succ and n_pump for a subject
      int n_succ = 0;  // Number of successful pumps
      int n_pump = 0;  // Number of total pumps
      real p_burst = phi[j];

      log_lik[j] = 0;

      for (k in 1:Tsubj[j]) {
        real u_gain = 1;
        real u_loss;
        real u_pump;
        real u_stop = 0;
        real delta_u;

        for (l in 1:(pumps[j, k] + 1 - explosion[j, k])) {
          // u_gain always equals r ^ rho.
          u_loss = (l - 1);

          u_pump = (1 - p_burst) * u_gain - lambda[j] * p_burst * u_loss +
          rho[j] * p_burst * (1 - p_burst) * (u_gain + lambda[j] * u_loss)^2;
          // u_stop always equals 0.

          delta_u = u_pump - u_stop;

          log_lik[j] += bernoulli_logit_lpmf(d[j, k, l] | tau[j] * delta_u);
          y_pred[j, k, l] = bernoulli_logit_rng(tau[j] * delta_u);
        }

        // Update n_succ and n_pump after each trial ends
        n_succ += pumps[j, k] - explosion[j, k];
        n_pump += pumps[j, k];

        p_burst = phi[j] + (1 - exp(-n_pump * eta[j])) * ((0.0 + n_pump - n_succ) / n_pump - phi[j]);
      }
    }
  }
}

