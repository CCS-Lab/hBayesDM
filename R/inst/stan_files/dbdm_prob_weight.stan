#include /pre/license.stan

data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  int<lower=-1, upper=2> choice[N, T];
  real<lower=0, upper=1> opt1hprob[N, T];
  real<lower=0, upper=1> opt2hprob[N, T];
  real opt1hval[N, T];
  real opt1lval[N, T];
  real opt2hval[N, T];
  real opt2lval[N, T];
}
transformed data {
}
parameters{
  //group-level parameters
  vector[4] mu_pr;
  vector<lower=0>[4] sigma;

  //subject-level raw parameters, follows norm(0,1), for later Matt Trick
  vector[N] tau_pr; //probability weight parameter
  vector[N] rho_pr; //subject utility parameter
  vector[N] lambda_pr; //loss aversion parameter
  vector[N] beta_pr; //inverse softmax temperature
}

transformed parameters {
  //subject-level parameters
  vector<lower=0, upper=1>[N] tau;
  vector<lower=0, upper=2>[N] rho;
  vector<lower=0, upper=5>[N] lambda;
  vector<lower=0, upper=1>[N] beta;

  //Matt Trick
  for (i in 1:N) {
    tau[i] = Phi_approx( mu_pr[1] + sigma[1] * tau_pr[i] );
    rho[i]  = Phi_approx( mu_pr[2] + sigma[2] * rho_pr[i] )*2;
    lambda[i]   = Phi_approx( mu_pr[3] + sigma[3] * lambda_pr[i] )*5;
    beta[i]    = Phi_approx( mu_pr[4] + sigma[4] * beta_pr[i] );
  }
}

model {
  //prior : hyperparameters
  mu_pr ~ normal(0,1);
  sigma ~ cauchy(0,5);

  //prior : individual parameters
  tau_pr ~ normal(0,1);
  rho_pr ~ normal(0,1);
  lambda_pr ~ normal(0,1);
  beta_pr ~ normal(0,1);

  //subject loop and trial loop
  for (i in 1:N) {
    for (t in 1:Tsubj[i]) {
      vector[4] w_prob;
      vector[2] U_opt;

      //probability weight function
      w_prob[1] = exp(-(-log(opt1hprob[i,t]))^tau[i]);
      w_prob[2] = exp(-(-log(1-opt1hprob[i,t]))^tau[i]);
      w_prob[3] = exp(-(-log(opt2hprob[i,t]))^tau[i]);
      w_prob[4] = exp(-(-log(1-opt2hprob[i,t]))^tau[i]);

      if (opt1hval[i,t]>0) {
        if (opt1lval[i,t]>= 0) {
          U_opt[1]  = w_prob[1]*(opt1hval[i,t]^rho[i]) + w_prob[2]*(opt1lval[i,t]^rho[i]);
        } else {
          U_opt[1] = w_prob[1]*(opt1hval[i,t]^rho[i]) - w_prob[2]*(fabs(opt1lval[i,t])^rho[i])*lambda[i];
        }
      } else {
        U_opt[1] = -w_prob[1]*(fabs(opt1hval[i,t])^rho[i])*lambda[i] - w_prob[2]*(fabs(opt1lval[i,t])^rho[i])*lambda[i];
        }

      if (opt2hval[i,t] > 0) {
        if (opt2lval[i,t] >= 0) {
          U_opt[2]  = w_prob[3]*(opt2hval[i,t]^rho[i]) + w_prob[4]*(opt2lval[i,t]^rho[i]);
        } else {
          U_opt[2] = w_prob[3]*(opt2hval[i,t]^rho[i]) - w_prob[4]*(fabs(opt2lval[i,t])^rho[i])*lambda[i];
        }
      } else {
        U_opt[2] = -w_prob[3]*(fabs(opt2hval[i,t])^rho[i])*lambda[i] -w_prob[4]*(fabs(opt2lval[i,t])^rho[i])*lambda[i];
        }
      // compute action probabilities
      choice[i, t] ~ categorical_logit(U_opt*beta[i]);
    }
  }
}

generated quantities {
  real<lower = 0, upper = 1> mu_tau;
  real<lower = 0, upper = 2> mu_rho;
  real<lower = 0, upper = 5> mu_lambda;
  real<lower = 0, upper = 1> mu_beta;
  real log_lik[N];
  // For posterior predictive check
  real y_pred[N,T];
  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = -1;
    }
  }

  mu_tau  = Phi_approx(mu_pr[1]);
  mu_rho  = Phi_approx(mu_pr[2])*2;
  mu_lambda  = Phi_approx(mu_pr[3])*5;
  mu_beta = Phi_approx(mu_pr[4]);

  { // local section, this saves time and space
    for (i in 1:N) {
      log_lik[i] = 0;
    for (t in 1:Tsubj[i]) {
      vector[4] w_prob;
      vector[2] U_opt;

      //probability weight function
      w_prob[1] = exp(-(-log(opt1hprob[i,t]))^tau[i]);
      w_prob[2] = exp(-(-log(1-opt1hprob[i,t]))^tau[i]);
      w_prob[3] = exp(-(-log(opt2hprob[i,t]))^tau[i]);
      w_prob[4] = exp(-(-log(1-opt2hprob[i,t]))^tau[i]);

      if (opt1hval[i,t]>0) {
        if (opt1lval[i,t]>= 0) {
          U_opt[1]  = w_prob[1]*(opt1hval[i,t]^rho[i]) + w_prob[2]*(opt1lval[i,t]^rho[i]);
        } else {
          U_opt[1] = w_prob[1]*(opt1hval[i,t]^rho[i]) - w_prob[2]*(fabs(opt1lval[i,t])^rho[i])*lambda[i];
        }
      } else {
        U_opt[1] = -w_prob[1]*(fabs(opt1hval[i,t])^rho[i])*lambda[i] - w_prob[2]*(fabs(opt1lval[i,t])^rho[i])*lambda[i];
        }

      if (opt2hval[i,t] > 0) {
        if (opt2lval[i,t] >= 0) {
          U_opt[2]  = w_prob[3]*(opt2hval[i,t]^rho[i]) + w_prob[4]*(opt2lval[i,t]^rho[i]);
        } else {
          U_opt[2] = w_prob[3]*(opt2hval[i,t]^rho[i]) - w_prob[4]*(fabs(opt2lval[i,t])^rho[i])*lambda[i];
        }
      } else {
        U_opt[2] = -w_prob[3]*(fabs(opt2hval[i,t])^rho[i])*lambda[i] -w_prob[4]*(fabs(opt2lval[i,t])^rho[i])*lambda[i];
        }

      // compute action probabilities
      log_lik[i] += categorical_logit_lpmf(choice[i,t] | U_opt*beta[i]);
      y_pred[i, t]  = categorical_rng(softmax(U_opt*beta[i]));

      }
    }
  }
}

