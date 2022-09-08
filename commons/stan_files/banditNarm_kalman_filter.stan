#include /pre/license.stan

data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  real rew[N, T];
  real los[N, T];
  int choice[N, T];
  int Narm;
}
transformed data {
  real sO; // sigma_O = 4
  sO = 4;
}


parameters {
  // group-level parameters
  vector[6] mu_pr;
  vector<lower=0>[6] sigma;

  // subject-level raw parameters, follows norm(0,1), for later Matt Trick
  vector[N] lambda_pr;    // decay factor
  vector[N] theta_pr;     // decay center
  vector[N] beta_pr;      // inverse softmax temperature
  vector[N] mu0_pr;       // anticipated initial mean of all 4 options
  vector[N] s0_pr; // anticipated initial sd^2 (uncertainty factor) of all 4 options
  vector[N] sD_pr; // sd^2 of diffusion noise
}

transformed parameters {
  // subject-level parameters
  vector<lower=0,upper=1>[N] lambda;
  vector<lower=0,upper=100>[N] theta;
  vector<lower=0,upper=1>[N] beta;
  vector<lower=0,upper=100>[N] mu0;
  vector<lower=0,upper=15>[N] s0;
  vector<lower=0,upper=15>[N] sD;

  // Matt Trick
  for (i in 1:N) {
    lambda[i] = Phi_approx( mu_pr[1] + sigma[1] * lambda_pr[i] );
    theta[i]  = Phi_approx( mu_pr[2] + sigma[2] * theta_pr[i] ) * 100;
    beta[i]   = Phi_approx( mu_pr[3] + sigma[3] * beta_pr[i] );
    mu0[i]    = Phi_approx( mu_pr[4] + sigma[4] * mu0_pr[i] ) * 100;
    s0[i] = Phi_approx( mu_pr[5] + sigma[5] * s0_pr[i] ) * 15;
    sD[i] = Phi_approx( mu_pr[6] + sigma[6] * sD_pr[i] ) * 15;
  }
}

model {
  // prior: hyperparameters
  mu_pr ~ normal(0,1);
  sigma ~ cauchy(0,5);

  // prior: individual parameters
  lambda_pr  ~ normal(0,1);;
  theta_pr   ~ normal(0,1);;
  beta_pr    ~ normal(0,1);;
  mu0_pr     ~ normal(0,1);;
  s0_pr ~ normal(0,1);;
  sD_pr ~ normal(0,1);;

  // subject loop and trial loop
  for (i in 1:N) {
    vector[Narm] mu_ev;    // estimated mean for each option
    vector[Narm] sd_ev_sq; // estimated sd^2 for each option
    real pe;            // prediction error
    real k;             // learning rate

    mu_ev    = rep_vector(mu0[i] ,Narm);
    sd_ev_sq = rep_vector(s0[i]^2, Narm);

    for (t in 1:(Tsubj[i])) {
      // compute action probabilities
      choice[i,t] ~ categorical_logit( beta[i] * mu_ev );

      // learning rate
      k = sd_ev_sq[choice[i,t]] / ( sd_ev_sq[choice[i,t]] + sO^2 );

      // prediction error
      pe = (rew[i,t]+los[i,t]) - mu_ev[choice[i,t]];

      // value updating (learning)
      mu_ev[choice[i,t]] += k * pe;
      sd_ev_sq[choice[i,t]] *= (1-k);

      // diffusion process
      {
        mu_ev    *= lambda[i];
        mu_ev    += (1 - lambda[i]) * theta[i];
      }
      {
        sd_ev_sq *= lambda[i]^2;
        sd_ev_sq += sD[i]^2;
      }
    }
  }
}

generated quantities {
  real<lower=0,upper=1> mu_lambda;
  real<lower=0,upper=100> mu_theta;
  real<lower=0,upper=1> mu_beta;
  real<lower=0,upper=100> mu_mu0;
  real<lower=0,upper=15> mu_s0;
  real<lower=0,upper=15> mu_sD;
  real log_lik[N];
  real y_pred[N,T];

  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = -1;
    }
  }

  mu_lambda = Phi_approx(mu_pr[1]);
  mu_theta  = Phi_approx(mu_pr[2]) * 100;
  mu_beta   = Phi_approx(mu_pr[3]);
  mu_mu0    = Phi_approx(mu_pr[4]) * 100;
  mu_s0 = Phi_approx(mu_pr[5]) * 15;
  mu_sD = Phi_approx(mu_pr[6]) * 15;

  { // local block
    for (i in 1:N) {
      vector[Narm] mu_ev;    // estimated mean for each option
      vector[Narm] sd_ev_sq; // estimated sd^2 for each option
      real pe;            // prediction error
      real k;             // learning rate

      log_lik[i] = 0;
      mu_ev    = rep_vector(mu0[i] ,Narm);
      sd_ev_sq = rep_vector(s0[i]^2, Narm);


      for (t in 1:(Tsubj[i])) {
        // compute action probabilities
        log_lik[i] += categorical_logit_lpmf( choice[i,t] | beta[i] * mu_ev );
        y_pred[i, t]  = categorical_rng(softmax(beta[i] * mu_ev));

        // learning rate
        k = sd_ev_sq[choice[i,t]] / ( sd_ev_sq[choice[i,t]] + sO^2);

        // prediction error
        pe = (rew[i,t]+los[i,t]) - mu_ev[choice[i,t]];

        // value updating (learning)
        mu_ev[choice[i,t]] += k * pe;
        sd_ev_sq[choice[i,t]] *= (1-k);

        // diffusion process
        {
          mu_ev    *= lambda[i];
          mu_ev    += (1 - lambda[i]) * theta[i];
        }
        {
          sd_ev_sq *= lambda[i]^2;
          sd_ev_sq += sD[i]^2;
        }
      }
    }
  } // local block END
}

