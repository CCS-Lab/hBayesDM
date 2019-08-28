data {
  int<lower=1> N;                        // Number of subjects
  int<lower=1> T;                        // Max trials per subject
  int<lower=1> B;                        // Number of bet options
  int<lower=1,upper=T> Tsubj[N];         // number of trials/subject
  int<lower=0,upper=2> col_chosen[N,T];  // chosen color index
  int<lower=0,upper=B> bet_chosen[N,T];  // chosen bet indexs
  vector[B] bet_delay;                   // vector of bet delays
  real gain[N,T,B];                      // gain: (capital + capital * bet_prop)
  real loss[N,T,B];                      // loss: (capital - capital * bet_prop)
  real prop_red[N,T];                    // proportion of red boxes
  real prop_chosen[N,T];                 // proportion of chosen boxes
}

parameters {
  // Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[5] mu_pr;
  vector<lower=0>[5] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] alpha_pr;
  vector[N] rho_pr;
  vector[N] gamma_pr;
  vector[N] c_pr;
  vector[N] beta_pr;
}

transformed parameters {
  // subject-level parameters
  vector<lower=0,upper=5>[N] alpha;
  vector<lower=0>[N] rho;
  vector<lower=0>[N] gamma;
  vector<lower=0,upper=1>[N] c;
  vector<lower=0>[N] beta;

  for (i in 1:N) {
    alpha[i] = Phi_approx( mu_pr[1] + sigma[1] * alpha_pr[i] ) * 5;
    c[i]     = Phi_approx( mu_pr[4] + sigma[4] * c_pr[i] );
  }
  rho   = exp(mu_pr[2] + sigma[2] * rho_pr);
  gamma = exp(mu_pr[3] + sigma[3] * gamma_pr);
  beta  = exp(mu_pr[5] + sigma[5] * beta_pr);
}

model {
  // Hyperpriors (vectorized)
  mu_pr ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // Individual parameters
  alpha_pr ~ normal(0,1);
  rho_pr   ~ normal(0,1);
  gamma_pr ~ normal(0,1);
  c_pr     ~ normal(0,1);
  beta_pr  ~ normal(0,1);

  // subject loop and trial loop
  for (i in 1:N) {
    // Define vectors
    vector[B] gain_util;
    vector[B] loss_util;
    vector[B] bet_util;
    vector[2] col_util;

    // Model
    for (t in 1:Tsubj[i]) {  // Need to set trial/vectorized parts correctly
      // Assign probability of choosing color (fix bias red)
      col_util[1] = (c[i] * pow(prop_red[i,t], alpha[i])) / (c[i] * pow(prop_red[i,t], alpha[i]) + ((1 - c[i]) * pow(1 - prop_red[i,t], alpha[i])));
      col_util[2] = 1 - col_util[1];

      // Increment log likelihood for color choice
      col_chosen[i,t] ~ categorical(col_util);

      // For each bet option
      for (b in 1:B) {
        // Assign gain/loss utilities
        gain_util[b] = log(1 + gain[i,t,b] * 1);
        loss_util[b] = log(1 + loss[i,t,b] * rho[i]);
      }

      // Utility of all bets
      bet_util = gain_util * prop_chosen[i,t] + loss_util * (1 - prop_chosen[i,t]);
      // Utility of bet with delays
      // bet_util = ((beta[i] + bet_util) / beta[i]) - beta[i] * bet_delay;
      bet_util = bet_util - beta[i] * bet_delay;

      // Increment log likelihood for choosing bet
      bet_chosen[i,t] ~ categorical_logit(bet_util * gamma[i]);
    }
  }
}

generated quantities {
  // Define group level parameters
  real<lower=0,upper=5> mu_alpha;
  real<lower=0>         mu_rho;
  real<lower=0>         mu_gamma;
  real<lower=0,upper=5> mu_c;
  real<lower=0>         mu_beta;

  // Define log likelihood vector
  real log_lik[N];
  real y_hat_col[N,T];
  real y_hat_bet[N,T];
  real bet_utils[N,T,B];

  for (j in 1:N) {
    for (k in 1:T) {
      y_hat_col[j,k] = 0;
      y_hat_bet[j,k] = 0;
      for (b in 1:B) {
        bet_utils[j,k,b] = 0;
      }
    }
  }

  // Assign group level parameters
  mu_alpha = Phi_approx(mu_pr[1]) * 5;
  mu_rho   = exp(mu_pr[2]);
  mu_gamma = exp(mu_pr[3]);
  mu_c     = Phi_approx(mu_pr[4]);
  mu_beta  = exp(mu_pr[5]);

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define vectors
      vector[B] gain_util;
      vector[B] loss_util;
      vector[B] bet_util;
      vector[2] col_util;

      log_lik[i] = 0;

      // Model
      for (t in 1:Tsubj[i]) {  // Need to set trial/vectorized parts correctly
        // Assign probability of choosing color (fix bias red)
        col_util[1] = (c[i] * pow(prop_red[i,t], alpha[i])) / (c[i] * pow(prop_red[i,t], alpha[i]) + ((1 - c[i]) * pow(1 - prop_red[i,t], alpha[i])));
        col_util[2] = 1 - col_util[1];

        // Increment log likelihood for color choice
        log_lik[i] = log_lik[i] + categorical_lpmf(col_chosen[i,t] | col_util);
        // Posterior prediction for bet
        y_hat_col[i,t] = categorical_rng(col_util);

        // For each bet option
        for (b in 1:B) {
          // Assign gain/loss utilities
          gain_util[b] = log(1 + gain[i,t,b] * 1);
          loss_util[b] = log(1 + loss[i,t,b] * rho[i]);
        }

        // Utility of all bets
        bet_util = gain_util * prop_chosen[i,t] + loss_util * (1 - prop_chosen[i,t]);
        // Utility of bet with delays
        // bet_util = ((beta[i] + bet_util) / beta[i]) - beta[i] * bet_delay;
        bet_util = bet_util - beta[i] * bet_delay;

        // Increment log likelihood for choosing bet
        log_lik[i] += categorical_logit_lpmf(bet_chosen[i,t] | bet_util * gamma[i]);
        // Posterior prediction for bet
        y_hat_bet[i,t] = categorical_rng(softmax(bet_util * gamma[i]));
        // Save bet utility
        for (b in 1:B) {
          bet_utils[i,t,b] = bet_util[b];
        }
      }
    }
  }
}
