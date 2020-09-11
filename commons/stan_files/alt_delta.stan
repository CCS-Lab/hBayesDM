#include /pre/license.stan

data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  int<lower=-1, upper=2> choice[N, T];
  real outcome[N, T];  // no lower and upper bounds
  real bluePunish[N, T];
  real orangePunish[N, T];
}
transformed data {
  real initV_ev;  // initial values for EV
  //vector[2] initV_gvalue;
  initV_ev = 0.5;
  //initV_gvalue = rep_vector(0.5, 2);
}
parameters {
// Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[3] mu_pr;
  vector<lower=0>[3] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] A_pr;    // learning rate
  vector[N] beta_pr; // inverse temperature
  vector[N] gamma_pr; // risk preference
}
transformed parameters {
  // subject-level parameters
  vector<lower=0, upper=1>[N] A;
  vector<lower=0, upper=20>[N] beta;
  vector<lower=0, upper=10>[N] gamma;

  for (i in 1:N) {
    A[i]   = Phi_approx(mu_pr[1]  + sigma[1]  * A_pr[i]);
    beta[i] = Phi_approx(mu_pr[2] + sigma[2] * beta_pr[i]) * 20;
    gamma[i] = Phi_approx(mu_pr[3] + sigma[3] * gamma_pr[i]) * 10;
  }
    //beta =exp(mu_pr[2] + sigma[2] * beta_pr);
}
model {
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0,0.2);
  //sigma[1:2] ~ normal(0, 0.2);
  //sigma[3] ~ cauchy(0, 1.0);

  // individual parameters
  A_pr ~ normal(0, 1.0);
  beta_pr ~ normal(0, 1.0);
  gamma_pr ~ normal(0, 1.0);

  // subject loop and trial loop
  for (i in 1:N) {
    real ev; // expected value
    vector[2] gvalue;
    vector[2] fvalue;
    real PE;      // prediction error

    ev = initV_ev;
    //gvalue = initV_gvalue;

    for (t in 1:(Tsubj[i])) {
      
      fvalue[1] = fmax(fmin((gamma[i]*(ev - 0.5) + 0.5), 1), 0);
      fvalue[2] = fmax(fmin((gamma[i]*(1 - ev - 0.5) + 0.5), 1), 0);
      //fvalue[2] = 1 - fvalue[1];
      gvalue[1] = fvalue[1] * bluePunish[i, t];
      gvalue[2] = fvalue[2] * orangePunish[i, t];

      // compute action probabilities
      choice[i, t] ~ categorical_logit((-beta[i]) * gvalue);

      // prediction error
      PE = outcome[i, t] - ev;

      // value updating (learning)
      ev += A[i] * PE;
      
    }
  }
}
generated quantities {
  // For group level parameters
  real<lower=0, upper=1> mu_A;
  real<lower=0, upper=20> mu_beta;
  real<lower=0, upper=10> mu_gamma;

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

  mu_A   = Phi_approx(mu_pr[1]);
  mu_beta = Phi_approx(mu_pr[2]) * 20;
  //mu_beta = exp(mu_pr[2]);
  mu_gamma = Phi_approx(mu_pr[3]) * 10;

  { // local section, this saves time and space
    for (i in 1:N) {
      real ev; // expected value
      vector[2] gvalue;
      vector[2] fvalue;
      real PE;      // prediction error

      // Initialize values
      ev = initV_ev;
      //gvalue = initV_gvalue;

      log_lik[i] = 0;

      for (t in 1:(Tsubj[i])) {
        
        fvalue[1] = fmax(fmin((gamma[i]*(ev - 0.5) + 0.5), 1), 0);
        fvalue[2] = fmax(fmin((gamma[i]*(1 - ev - 0.5) + 0.5), 1), 0);
        //fvalue[2] = 1 - fvalue[1];
        gvalue[1] = fvalue[1] * bluePunish[i, t];
        gvalue[2] = fvalue[2] * orangePunish[i, t];

        // compute log likelihood of current trial
        log_lik[i] += categorical_logit_lpmf(choice[i, t] | (-beta[i]) * gvalue);

        // generate posterior prediction for current trial
        y_pred[i, t] = categorical_rng(softmax((-beta[i]) * gvalue));

        // prediction error
        PE = outcome[i, t] - ev;

        // value updating (learning)
        ev += A[i] * PE;

      }
    }
  }
}

