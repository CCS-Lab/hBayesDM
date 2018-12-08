#include /pre/license.stan

/**
 * Choice under Risk and Ambiguity Task
 *
 * Exponential model in Hsu et al. (2005) Science
 */

functions {
  /**
   * Subjective value function with the exponential equation form
   */
  real subjective_value(real alpha, real beta, real p, real a, real v) {
    return pow(p, 1 + beta * a) * pow(v, alpha);
  }
}

data {
  int<lower=1> N;                     // Number of subjects
  int<lower=1> T;                     // Max number of trials across subjects
  int<lower=1,upper=T> Tsubj[N];      // Number of trials/block for each subject

  int<lower=0,upper=1> choice[N, T];  // The options subjects choose (0: fixed / 1: variable)
  real<lower=0,upper=1> prob[N, T];   // The objective probability of the variable lottery
  real<lower=0,upper=1> ambig[N, T];  // The ambiguity level of the variable lottery (0 for risky lottery)
  real<lower=0> reward_var[N, T];     // The amount of reward values on variable lotteries (risky and ambiguity conditions)
  real<lower=0> reward_fix[N, T];     // The amount of reward values on fixed lotteries (reference)
}

// Declare all parameters as vectors for vectorizing
parameters {
  // Hyper(group)-parameters
  vector[3] mu_pr;
  vector<lower=0>[3] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] alpha_pr;   // risk attitude parameter
  vector[N] beta_pr;    // ambiguity attitude parameter
  vector[N] gamma_pr;   // inverse temperature parameter
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0,upper=2>[N] alpha;
  vector[N]                  beta;
  vector<lower=0>[N]         gamma;

  alpha = Phi_approx(mu_pr[1] + sigma[1] * alpha_pr) * 2;
  beta  = mu_pr[2] + sigma[2] * beta_pr;
  gamma = exp(mu_pr[3] + sigma[3] * gamma_pr);
}

model {
  // hyper parameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0, 5);

  // individual parameters w/ Matt trick
  alpha_pr ~ normal(0, 1);
  beta_pr  ~ normal(0, 1);
  gamma_pr ~ normal(0, 1);

  for (i in 1:N) {
    for (t in 1:Tsubj[i]) {
      real u_fix;  // subjective value of the fixed lottery
      real u_var;  // subjective value of the variable lottery
      real p_var;  // probability of choosing the variable option

      u_fix = subjective_value(alpha[i], beta[i], 0.5, 0, reward_fix[i, t]);
      u_var = subjective_value(alpha[i], beta[i], prob[i, t], ambig[i, t], reward_var[i, t]);
      p_var = inv_logit(gamma[i] * (u_var - u_fix));

      target += bernoulli_lpmf(choice[i, t] | p_var);
    }
  }
}

generated quantities {
  // For group level parameters
  real<lower=0,upper=2> mu_alpha;
  real                  mu_beta;
  real<lower=0>         mu_gamma;

  // For log likelihood calculation for each subject
  real log_lik[N];

  // For posterior predictive check
  real y_pred[N, T];

  // Model regressors
  real sv[N, T];
  real sv_fix[N, T];
  real sv_var[N, T];
  real<lower=0,upper=1> p_var[N, T];

  // Set all posterior predictions to -1 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = -1;
      sv[i, t] = 0;
      sv_fix[i, t] = 0;
      sv_var[i, t] = 0;
      p_var[i, t] = 0;
    }
  }

  mu_alpha  = Phi_approx(mu_pr[1]) * 2;
  mu_beta   = mu_pr[2];
  mu_gamma  = exp(mu_pr[3]);

  { // local section, this saves time and space
    for (i in 1:N) {
      // Initialize the log likelihood variable to 0.
      log_lik[i] = 0;

      for (t in 1:Tsubj[i]) {
        real u_fix;  // subjective value of the fixed lottery
        real u_var;  // subjective value of the variable lottery

        u_fix = subjective_value(alpha[i], beta[i], 0.5, 0, reward_fix[i, t]);
        u_var = subjective_value(alpha[i], beta[i], prob[i, t], ambig[i, t], reward_var[i, t]);
        p_var[i, t] = inv_logit(gamma[i] * (u_var - u_fix));

        sv_fix[i, t] = u_fix;
        sv_var[i, t] = u_var;
        sv[i, t] = (choice[i, t] == 1) ? u_var : u_fix;

        log_lik[i] += bernoulli_lpmf(choice[i, t] | p_var[i, t]);
        y_pred[i, t] = bernoulli_rng(p_var[i, t]);
      }
    }
  }
}

