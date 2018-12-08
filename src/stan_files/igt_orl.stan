#include /pre/license.stan

data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  int choice[N, T];
  real outcome[N, T];
  real sign_out[N, T];
}
transformed data {
  vector[4] initV;
  initV  = rep_vector(0.0, 4);
}
parameters {
// Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[5] mu_pr;
  vector<lower=0>[5] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] Arew_pr;
  vector[N] Apun_pr;
  vector[N] K_pr;
  vector[N] betaF_pr;
  vector[N] betaP_pr;
}
transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0, upper=1>[N] Arew;
  vector<lower=0, upper=1>[N] Apun;
  vector<lower=0, upper=5>[N] K;
  vector[N]                   betaF;
  vector[N]                   betaP;

  for (i in 1:N) {
    Arew[i] = Phi_approx( mu_pr[1] + sigma[1] * Arew_pr[i] );
    Apun[i] = Phi_approx( mu_pr[2] + sigma[2] * Apun_pr[i] );
    K[i]    = Phi_approx(mu_pr[3] + sigma[3] + K_pr[i]) * 5;
  }
  betaF = mu_pr[4] + sigma[4] * betaF_pr;
  betaP = mu_pr[5] + sigma[5] * betaP_pr;
}
model {
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma[1:3] ~ normal(0, 0.2);
  sigma[4:5] ~ cauchy(0, 1.0);

  // individual parameters
  Arew_pr  ~ normal(0, 1.0);
  Apun_pr  ~ normal(0, 1.0);
  K_pr     ~ normal(0, 1.0);
  betaF_pr ~ normal(0, 1.0);
  betaP_pr ~ normal(0, 1.0);

  for (i in 1:N) {
    // Define values
    vector[4] ef;
    vector[4] ev;
    vector[4] PEfreq_fic;
    vector[4] PEval_fic;
    vector[4] pers;   // perseverance
    vector[4] util;

    real PEval;
    real PEfreq;
    real efChosen;
    real evChosen;
    real K_tr;

    // Initialize values
    ef    = initV;
    ev    = initV;
    pers  = initV; // initial pers values
    util  = initV;
    K_tr = pow(3, K[i]) - 1;

    for (t in 1:Tsubj[i]) {
      // softmax choice
      choice[i, t] ~ categorical_logit( util );

      // Prediction error
      PEval  = outcome[i,t] - ev[ choice[i,t]];
      PEfreq = sign_out[i,t] - ef[ choice[i,t]];
      PEfreq_fic = -sign_out[i,t]/3 - ef;

      // store chosen deck ev
      efChosen = ef[ choice[i,t]];
      evChosen = ev[ choice[i,t]];

      if (outcome[i,t] >= 0) {
        // Update ev for all decks
        ef += Apun[i] * PEfreq_fic;
        // Update chosendeck with stored value
        ef[ choice[i,t]] = efChosen + Arew[i] * PEfreq;
        ev[ choice[i,t]] = evChosen + Arew[i] * PEval;
      } else {
        // Update ev for all decks
        ef += Arew[i] * PEfreq_fic;
        // Update chosendeck with stored value
        ef[ choice[i,t]] = efChosen + Apun[i] * PEfreq;
        ev[ choice[i,t]] = evChosen + Apun[i] * PEval;
      }

      // Perseverance updating
      pers[ choice[i,t] ] = 1;   // perseverance term
      pers /= (1 + K_tr);        // decay

      // Utility of expected value and perseverance
      util  = ev + ef * betaF[i] + pers * betaP[i];
    }
  }
}

generated quantities {
  // For group level parameters
  real<lower=0,upper=1> mu_Arew;
  real<lower=0,upper=1> mu_Apun;
  real<lower=0,upper=5> mu_K;
  real                  mu_betaF;
  real                  mu_betaP;

  // For log likelihood calculation
  real log_lik[N];

  // For posterior predictive check
  real y_pred[N,T];

  // Set all posterior predictions to -1 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i,t] = -1;
    }
  }

  mu_Arew   = Phi_approx(mu_pr[1]);
  mu_Apun   = Phi_approx(mu_pr[2]);
  mu_K      = Phi_approx(mu_pr[3]) * 5;
  mu_betaF  = mu_pr[4];
  mu_betaP  = mu_pr[5];

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define values
      vector[4] ef;
      vector[4] ev;
      vector[4] PEfreq_fic;
      vector[4] PEval_fic;
      vector[4] pers;   // perseverance
      vector[4] util;

      real PEval;
      real PEfreq;
      real efChosen;
      real evChosen;
      real K_tr;

      // Initialize values
      log_lik[i] = 0;
      ef    = initV;
      ev    = initV;
      pers  = initV; // initial pers values
      util  = initV;
      K_tr = pow(3, K[i]) - 1;

      for (t in 1:Tsubj[i]) {
        // softmax choice
        log_lik[i] += categorical_logit_lpmf( choice[i, t] | util );

        // generate posterior prediction for current trial
        y_pred[i,t] = categorical_rng(softmax(util));

        // Prediction error
        PEval  = outcome[i,t] - ev[ choice[i,t]];
        PEfreq = sign_out[i,t] - ef[ choice[i,t]];
        PEfreq_fic = -sign_out[i,t]/3 - ef;

        // store chosen deck ev
        efChosen = ef[ choice[i,t]];
        evChosen = ev[ choice[i,t]];

        if (outcome[i,t] >= 0) {
          // Update ev for all decks
          ef += Apun[i] * PEfreq_fic;
          // Update chosendeck with stored value
          ef[ choice[i,t]] = efChosen + Arew[i] * PEfreq;
          ev[ choice[i,t]] = evChosen + Arew[i] * PEval;
        } else {
          // Update ev for all decks
          ef += Arew[i] * PEfreq_fic;
          // Update chosendeck with stored value
          ef[ choice[i,t]] = efChosen + Apun[i] * PEfreq;
          ev[ choice[i,t]] = evChosen + Apun[i] * PEval;
        }

        // Perseverance updating
        pers[ choice[i,t] ] = 1;   // perseverance term
        pers /= (1 + K_tr);        // decay

        // Utility of expected value and perseverance
        util  = ev + ef * betaF[i] + pers * betaP[i];
      }
    }
  }
}

