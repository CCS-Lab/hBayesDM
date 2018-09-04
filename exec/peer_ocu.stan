data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  int<lower=-1, upper=1> choice[N, T];
  int<lower=0, upper=3> condition[N, T]; // 0: solo, 1: ss, 2: mix, 3: rr
  real safe_Hpayoff[N, T];
  real safe_Lpayoff[N, T];
  real risky_Hpayoff[N, T];
  real risky_Lpayoff[N, T];
  real<lower=0, upper=1> p_gamble[N, T];
}

transformed data {
}

parameters {
  vector[3] mu_p;
  vector<lower=0>[3] sigma;
  vector[N] rho_p;
  vector[N] tau_p;
  vector[N] ocu_p;
}

transformed parameters {
  vector<lower=0, upper=2>[N] rho;
  vector<lower=0>[N] tau;
  vector[N] ocu;

  for (i in 1:N) {
    rho[i] = Phi_approx(mu_p[1] + sigma[1] * rho_p[i]) * 2;
  }
  tau = exp(mu_p[2] + sigma[2] * tau_p);
  ocu = mu_p[3] + sigma[3] * ocu_p;
}

model {
  // peer_ocu
  // hyper parameters
  mu_p  ~ normal(0, 1.0);
  sigma[1:2] ~ normal(0, 0.2);
  sigma[3]   ~ cauchy(0, 1.0);

  // individual parameters w/ Matt trick
  rho_p ~ normal(0, 1.0);
  tau_p ~ normal(0, 1.0);
  ocu_p ~ normal(0, 1.0);

  for (i in 1:N) {
    for (t in 1:Tsubj[i]) {
      real U_safe;
      real U_risky;

      U_safe  = p_gamble[i, t] * pow(safe_Hpayoff[i, t], rho[i])  + (1-p_gamble[i, t]) * pow(safe_Lpayoff[i, t], rho[i]);
      U_risky = p_gamble[i, t] * pow(risky_Hpayoff[i, t], rho[i]) + (1-p_gamble[i, t]) * pow(risky_Lpayoff[i, t], rho[i]);
      if (condition[i, t] == 1) {  // safe-safe
        U_safe = U_safe + ocu[i];
      }
      if (condition[i, t] == 3) {  // risky-risky
        U_risky = U_risky + ocu[i];
      }
      choice[i, t] ~ bernoulli_logit(tau[i] * (U_risky - U_safe));
    }
  }
}
generated quantities {
  real<lower=0, upper=2> mu_rho;
  real<lower=0> mu_tau;
  real mu_ocu;

  // For log likelihood calculation
  real log_lik[N];

  // For posterior predictive check
  real y_pred[N, T];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = -1;
    }
  }

  mu_rho = Phi_approx(mu_p[1]) * 2;
  mu_tau = exp(mu_p[2]);
  mu_ocu = mu_p[3];

  { // local section, this saves time and space
    for (i in 1:N) {

      // Initialize values
      log_lik[i] = 0.0;

      for (t in 1:Tsubj[i]) {
        real U_safe;
        real U_risky;

        U_safe  = p_gamble[i, t] * pow(safe_Hpayoff[i, t], rho[i])  + (1-p_gamble[i, t]) * pow(safe_Lpayoff[i, t], rho[i]);
        U_risky = p_gamble[i, t] * pow(risky_Hpayoff[i, t], rho[i]) + (1-p_gamble[i, t]) * pow(risky_Lpayoff[i, t], rho[i]);
        if (condition[i, t] == 1) {  // safe-safe
          U_safe = U_safe + ocu[i];
        }
        if (condition[i, t] == 3) {  // risky-risky
          U_risky = U_risky + ocu[i];
        }
        log_lik[i] = log_lik[i] + bernoulli_logit_lpmf(choice[i, t] | tau[i] * (U_risky - U_safe));
        // generate posterior prediction for current trial
        y_pred[i, t] = bernoulli_rng(inv_logit(tau[i] * (U_risky - U_safe)));
      }
    }
  }
}

