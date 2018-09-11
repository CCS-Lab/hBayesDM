data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  int<lower=-1, upper=1> gamble[N, T];
  int<lower=-1, upper=1> type[N, T];
  real cert[N, T];
  real<lower=0> gain[N, T];
  real<lower=0> loss[N, T];  // absolute loss amount
  real outcome[N, T];
  real happy[N, T];
  real RT_happy[N, T];
}
transformed data {
}
parameters {
  vector[6] mu_p;
  vector<lower=0>[6] sigma;
  vector[N] w0_p;
  vector[N] w1_p;
  vector[N] w2_p;
  vector[N] w3_p;
  vector[N] gam_p;
  vector[N] sig_p;
}
transformed parameters {
  vector[N] w0;
  vector[N] w1;
  vector[N] w2;
  vector[N] w3;
  vector<lower=0, upper=1>[N] gam;
  vector<lower=0>[N] sig;

  w0 = mu_p[1] + sigma[1] * w0_p;
  w1 = mu_p[2] + sigma[2] * w1_p;
  w2 = mu_p[3] + sigma[3] * w2_p;
  w3 = mu_p[4] + sigma[4] * w3_p;

  for (i in 1:N) {
    gam[i]    = Phi_approx(mu_p[5] + sigma[5] * gam_p[i]);
  }
  sig = exp(mu_p[6] + sigma[6] * sig_p);
}
model {
  mu_p  ~ normal(0, 1.0);
  sigma ~ normal(0, 0.2);

  // individual parameters w/ Matt trick
  w0_p    ~ normal(0, 1.0);
  w1_p    ~ normal(0, 1.0);
  w2_p    ~ normal(0, 1.0);
  w3_p    ~ normal(0, 1.0);
  gam_p   ~ normal(0, 1.0);
  sig_p   ~ normal(0, 1.0);

  for (i in 1:N) {
    real cert_sum;
    real ev_sum;
    real rpe_sum;


    cert_sum = 0;
    ev_sum = 0;
    rpe_sum = 0;

    for (t in 1:Tsubj[i]) {
      if(t == 1 || t > 1 && RT_happy[i,t] != RT_happy[i,t-1]){
        happy[i,t] ~ normal(w0[i] + w1[i] * cert_sum + w2[i] * ev_sum + w3[i] * rpe_sum, sig[i]);
      }

      if(gamble[i,t] == 0){
        cert_sum = cert_sum + type[i,t] * cert[i,t];
      } else {
        ev_sum = ev_sum + 0.5 * (gain[i,t] - loss[i,t]);
        rpe_sum = rpe_sum + outcome[i,t] - 0.5 * (gain[i,t] - loss[i,t]);
      }

      cert_sum = gam[i] * cert_sum;
      ev_sum = gam[i] * ev_sum;
      rpe_sum = gam[i] * rpe_sum;
    }
  }
}
generated quantities {
  real mu_w0;
  real mu_w1;
  real mu_w2;
  real mu_w3;
  real<lower=0, upper=1> mu_gam;
  real<lower=0> mu_sig;

  real log_lik[N];

  // For posterior predictive check
  real y_pred[N, T];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = -1;
    }
  }

  mu_w0    = mu_p[1];
  mu_w1    = mu_p[2];
  mu_w2    = mu_p[3];
  mu_w3    = mu_p[4];
  mu_gam   = Phi_approx(mu_p[5]);
  mu_sig   = exp(mu_p[6]);


  { // local section, this saves time and space
    for (i in 1:N) {
      real cert_sum;
      real ev_sum;
      real rpe_sum;

      log_lik[i] = 0;

      cert_sum = 0;
      ev_sum = 0;
      rpe_sum = 0;

      for (t in 1:Tsubj[i]) {
        if(t == 1 || t > 1 && RT_happy[i,t] != RT_happy[i,t-1]){
          log_lik[i] = log_lik[i] + normal_lpdf(happy[i, t] | w0[i] + w1[i] * cert_sum + w2[i] * ev_sum + w3[i] * rpe_sum, sig[i]);
          y_pred[i, t] = normal_rng(w0[i] + w1[i] * cert_sum + w2[i] * ev_sum + w3[i] * rpe_sum, sig[i]);
        }

        if(gamble[i,t] == 0){
          cert_sum = cert_sum + type[i,t] * cert[i,t];
        } else {
          ev_sum = ev_sum + 0.5 * (gain[i,t] - loss[i,t]);
          rpe_sum = rpe_sum + outcome[i,t] - 0.5 * (gain[i,t] - loss[i,t]);
        }

        cert_sum = gam[i] * cert_sum;
        ev_sum = gam[i] * ev_sum;
        rpe_sum = gam[i] * rpe_sum;
      }
    }
  }
}

