data {
  int<lower=1> N;     // Number of subjects
  int<lower=1> T;     // Maximum number of trials
  int<lower=1> L;     // Number of levels
  int<lower=1,upper=T> Tsubj[N];   // Number of trials/block for each subject
  real input[N, T];   // Input for each trial-level
  int<lower=0,upper=1> response[N, T];    // Response for each trial-level

  // Perceptual uncertainty value
  real eta_a;
  real eta_b;
  real alpha;
}

parameters {
  // Parameters for the perceptual model
  real omega;
  real log_kappa;
  real theta;

  // Parameters for the observation model
  real log_zeta;    // log inverse response noise
}

transformed parameters {
  real kappa = exp(log_kappa);
  real zeta = exp(log_zeta);
}

model {
  // prior for parameters
  log_kappa ~ normal(log(1), 0.01);
  omega ~ normal(-3, 4^2);
  log_zeta ~ normal(log(48), 1);
  theta ~ normal(0.5, 0.5);

  {
    //Representations
    real mu[N, T, L];
    real pi[N, T, L];

    // Other quantities
    real muhat[N, T, L];
    real pihat[N, T, L];
    real v[N, T, L];
    real w[N, T, L-1];
    real da[N, T, L];
    real temp_a;
    real temp_b;

    // After applying the unit square sigmoid function
    real uni_sq_sigm[N, T];

    // Initial values
    vector[L] mu_0;
    vector[L] log_sa_0;
    vector[L] sa_0;

    mu_0[2] = 0;
    mu_0[3] = 1;
    for (sa in 1:L) {
      log_sa_0[sa] = log(0.1);
    }
    sa_0 = exp(log_sa_0);

    for (n in 1:N) {
      for (t in 1:Tsubj[n]) {
        // 2nd level prediction
        if (t == 1){
          muhat[n, t, 2] = mu_0[2];
        } else {
          muhat[n, t, 2] = mu[n, t-1, 2];
        }

        // 1st level
        // ~~~~~~~~~
          // prediction
        muhat[n, t, 1] = inv_logit(muhat[n, t, 2]);

        // Precision of prediction
        pihat[n, t, 1] = 1.0/(muhat[n, t, 1]*(1- muhat[n, t, 1]));

        // updates
        temp_a  = exp(-pow(input[n, t]-eta_a, 2)/(2*alpha));
        temp_b  = exp(-pow(input[n, t]-eta_b, 2)/(2*alpha));
        mu[n, t, 1] =  (temp_a * inv_logit(muhat[n, t, 2])) / (temp_a * inv_logit(muhat[n, t, 2]) + temp_b * (1-inv_logit(muhat[n, t, 2])));

        // prediction error
        da[n, t, 1] = mu[n, t, 1]-muhat[n, t, 1];


        // 2nd level
        // ~~~~~~~~~
          // Precision of prediction
        if (t == 1) {
          pihat[n, t, 2] = 1.0/(sa_0[2]+exp(kappa*mu_0[3]+omega));
        } else {
          pihat[n, t, 2] = 1.0/(1.0/pi[n, t-1, 2]+exp(kappa*mu[n, t-1, 3]+omega));
        }

        // Updates
        pi[n, t, 2] = pihat[n, t, 2]+1/pihat[n, t, 1];
        mu[n, t, 2] = muhat[n, t, 2]+1/pi[n, t, 2]*da[n, t, 1];

        // Volatility prediction error
        da[n, t, 2] = (1/pi[n, t, 2] + (mu[n, t, 2]-muhat[n, t, 2])^2) * pihat[n, t, 2]-1;

        // Last level
        // ~~~~~~~~~
          // Prediction & Precision of prediction & Weighting factor
        if (t == 1){
          muhat[n, t, L] = mu_0[L];
          pihat[n, t, L] = 1/(sa_0[L] + theta);
          v[n, t, L-1] = exp(kappa*mu_0[L] + omega);
        } else {
          muhat[n, t, L] = mu[n, t-1, L];
          pihat[n, t, L] = 1/(1/pi[n, t-1, L] + theta);
          v[n, t, L-1] = exp(kappa*mu[n, t-1, L] + omega);
        }

        // Weighting factor
        v[n, t, L] = theta;
        w[n, t, L-1] = v[n, t, L-1]*pihat[n, t, L-1];

        // Updates
        pi[n, t, L] = pihat[n, t, L] + 0.5 * kappa^2 * w[n, t, L-1] * (w[n, t, L-1] + (2*w[n, t, L-1]-1)*da[n, t, L-1]);
        mu[n, t, L] = muhat[n, t, L] + 0.5 * 1/pi[n, t, L] * kappa * w[n, t, L-1] * da[n, t, L-1];

        // Volatility prediction error
        da[n, t, L] = (1/pi[n, t, L] + (mu[n, t, L]-muhat[n, t, L])^2) * pihat[n, t, L]-1;

        // Unit square sigmoid function
        uni_sq_sigm[n, t] = muhat[n, t, 1]^zeta/(muhat[n, t, 1]^zeta + (1-muhat[n, t, 1])^zeta);
        target += bernoulli_lpmf(response[n, t] | uni_sq_sigm[n, t]);
      }
    }
  }
}

generated quantities {
  vector[N] log_lik = rep_vec(0, N);

  {
    //Representations
    real mu[N, T, L];
    real pi[N, T, L];

    // Other quantities
    real muhat[N, T, L];
    real pihat[N, T, L];
    real v[N, T, L];
    real w[N, T, L-1];
    real da[N, T, L];
    real temp_a;
    real temp_b;

    // After applying the unit square sigmoid function
    real uni_sq_sigm[N, T];

    // Initial values
    vector[L] mu_0;
    vector[L] log_sa_0;
    vector[L] sa_0;

    mu_0[2] = 0;
    mu_0[3] = 1;
    for (sa in 1:L) {
      log_sa_0[sa] = log(0.1);
    }
    sa_0 = exp(log_sa_0);

    for (n in 1:N) {
      for (t in 1:Tsubj[n]) {
        // 2nd level prediction
        if (t == 1){
          muhat[n, t, 2] = mu_0[2];
        } else {
          muhat[n, t, 2] = mu[n, t-1, 2];
        }

        // 1st level
        // ~~~~~~~~~
          // prediction
        muhat[n, t, 1] = inv_logit(muhat[n, t, 2]);

        // Precision of prediction
        pihat[n, t, 1] = 1.0/(muhat[n, t, 1]*(1- muhat[n, t, 1]));

        // updates
        temp_a  = exp(-pow(input[n, t]-eta_a, 2)/(2*alpha));
        temp_b  = exp(-pow(input[n, t]-eta_b, 2)/(2*alpha));
        mu[n, t, 1] =  (temp_a * inv_logit(muhat[n, t, 2])) / (temp_a * inv_logit(muhat[n, t, 2]) + temp_b * (1-inv_logit(muhat[n, t, 2])));

        // prediction error
        da[n, t, 1] = mu[n, t, 1]-muhat[n, t, 1];


        // 2nd level
        // ~~~~~~~~~
          // Precision of prediction
        if (t == 1) {
          pihat[n, t, 2] = 1.0/(sa_0[2]+exp(kappa*mu_0[3]+omega));
        } else {
          pihat[n, t, 2] = 1.0/(1.0/pi[n, t-1, 2]+exp(kappa*mu[n, t-1, 3]+omega));
        }

        // Updates
        pi[n, t, 2] = pihat[n, t, 2]+1/pihat[n, t, 1];
        mu[n, t, 2] = muhat[n, t, 2]+1/pi[n, t, 2]*da[n, t, 1];

        // Volatility prediction error
        da[n, t, 2] = (1/pi[n, t, 2] + (mu[n, t, 2]-muhat[n, t, 2])^2) * pihat[n, t, 2]-1;

        // Last level
        // ~~~~~~~~~
          // Prediction & Precision of prediction & Weighting factor
        if (t == 1){
          muhat[n, t, L] = mu_0[L];
          pihat[n, t, L] = 1/(sa_0[L] + theta);
          v[n, t, L-1] = exp(kappa*mu_0[L] + omega);
        } else {
          muhat[n, t, L] = mu[n, t-1, L];
          pihat[n, t, L] = 1/(1/pi[n, t-1, L] + theta);
          v[n, t, L-1] = exp(kappa*mu[n, t-1, L] + omega);
        }

        // Weighting factor
        v[n, t, L] = theta;
        w[n, t, L-1] = v[n, t, L-1]*pihat[n, t, L-1];

        // Updates
        pi[n, t, L] = pihat[n, t, L] + 0.5 * kappa^2 * w[n, t, L-1] * (w[n, t, L-1] + (2*w[n, t, L-1]-1)*da[n, t, L-1]);
        mu[n, t, L] = muhat[n, t, L] + 0.5 * 1/pi[n, t, L] * kappa * w[n, t, L-1] * da[n, t, L-1];

        // Volatility prediction error
        da[n, t, L] = (1/pi[n, t, L] + (mu[n, t, L]-muhat[n, t, L])^2) * pihat[n, t, L]-1;

        // Unit square sigmoid function
        uni_sq_sigm[n, t] = muhat[n, t, 1]^zeta/(muhat[n, t, 1]^zeta + (1-muhat[n, t, 1])^zeta);
        log_lik[i] += bernoulli_lpmf(response[n, t] | uni_sq_sigm[n, t]);
      }
    }
  }
}
