#include /pre/license.stan

// Seymour et al 2012 J neuro model, w/o C (chioce perseveration) but with xi (lapse rate)
data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  real rew[N, T];
  real los[N, T];
  int choice[N, T];
}

transformed data {
  vector[4] initV;
  initV = rep_vector(0.0, 4);
}

parameters {
  // Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[5] mu_pr;
  vector<lower=0>[5] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] Arew_pr;
  vector[N] Apun_pr;
  vector[N] R_pr;
  vector[N] P_pr;
  vector[N] xi_pr;
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0, upper=1>[N] Arew;
  vector<lower=0, upper=1>[N] Apun;
  vector<lower=0, upper=30>[N] R;
  vector<lower=0, upper=30>[N] P;
  vector<lower=0, upper=1>[N] xi;

  for (i in 1:N) {
    Arew[i] = Phi_approx(mu_pr[1] + sigma[1] * Arew_pr[i]);
    Apun[i] = Phi_approx(mu_pr[2] + sigma[2] * Apun_pr[i]);
    R[i]    = Phi_approx(mu_pr[3] + sigma[3] * R_pr[i]) * 30;
    P[i]    = Phi_approx(mu_pr[4] + sigma[4] * P_pr[i]) * 30;
    xi[i]   = Phi_approx(mu_pr[5] + sigma[5] * xi_pr[i]);
  }
}

model {
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // individual parameters
  Arew_pr  ~ normal(0, 1.0);
  Apun_pr  ~ normal(0, 1.0);
  R_pr     ~ normal(0, 1.0);
  P_pr     ~ normal(0, 1.0);
  xi_pr    ~ normal(0, 1.0);

  for (i in 1:N) {
    // Define values
    vector[4] Qr;
    vector[4] Qp;
    vector[4] PEr_fic; // prediction error - for reward fictive updating (for unchosen options)
    vector[4] PEp_fic; // prediction error - for punishment fictive updating (for unchosen options)
    vector[4] Qsum;    // Qsum = Qrew + Qpun + perseverance

    real Qr_chosen;
    real Qp_chosen;
    real PEr; // prediction error - for reward of the chosen option
    real PEp; // prediction error - for punishment of the chosen option

    // Initialize values
    Qr    = initV;
    Qp    = initV;
    Qsum  = initV;

    for (t in 1:Tsubj[i]) {
      // softmax choice + xi (noise)
      choice[i, t] ~ categorical(softmax(Qsum) * (1-xi[i]) + xi[i]/4);

      // Prediction error signals
      PEr     = R[i] * rew[i, t] - Qr[choice[i, t]];
      PEp     = P[i] * los[i, t] - Qp[choice[i, t]];
      PEr_fic = -Qr;
      PEp_fic = -Qp;

      // store chosen deck Q values (rew and pun)
      Qr_chosen = Qr[choice[i, t]];
      Qp_chosen = Qp[choice[i, t]];

      // First, update Qr & Qp for all decks w/ fictive updating
      Qr += Arew[i] * PEr_fic;
      Qp += Apun[i] * PEp_fic;
      // Replace Q values of chosen deck with correct values using stored values
      Qr[choice[i, t]] = Qr_chosen + Arew[i] * PEr;
      Qp[choice[i, t]] = Qp_chosen + Apun[i] * PEp;

      // Q(sum)
      Qsum = Qr + Qp;
    }
  }
}
generated quantities {
  // For group level parameters
  real<lower=0, upper=1> mu_Arew;
  real<lower=0, upper=1> mu_Apun;
  real<lower=0, upper=30> mu_R;
  real<lower=0, upper=30> mu_P;
  real<lower=0, upper=1> mu_xi;

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

  mu_Arew = Phi_approx(mu_pr[1]);
  mu_Apun = Phi_approx(mu_pr[2]);
  mu_R    = Phi_approx(mu_pr[3]) * 30;
  mu_P    = Phi_approx(mu_pr[4]) * 30;
  mu_xi   = Phi_approx(mu_pr[5]);

  { // local section, this saves time and space
    for (i in 1:N) {
      // Define values
      vector[4] Qr;
      vector[4] Qp;
      vector[4] PEr_fic; // prediction error - for reward fictive updating (for unchosen options)
      vector[4] PEp_fic; // prediction error - for punishment fictive updating (for unchosen options)
      vector[4] Qsum;    // Qsum = Qrew + Qpun + perseverance

      real Qr_chosen;
      real Qp_chosen;
      real PEr; // prediction error - for reward of the chosen option
      real PEp; // prediction error - for punishment of the chosen option

      // Initialize values
      Qr   = initV;
      Qp   = initV;
      Qsum  = initV;
      log_lik[i] = 0.0;

      for (t in 1:Tsubj[i]) {
        // compute log likelihood of current trial
        log_lik[i] += categorical_lpmf(choice[i, t] | softmax(Qsum) * (1-xi[i]) + xi[i]/4);

        // generate posterior prediction for current trial
        y_pred[i, t] = categorical_rng(softmax(Qsum) * (1-xi[i]) + xi[i]/4);

        // Prediction error signals
        PEr     = R[i] * rew[i, t] - Qr[choice[i, t]];
        PEp     = P[i] * los[i, t] - Qp[choice[i, t]];
        PEr_fic = -Qr;
        PEp_fic = -Qp;

        // store chosen deck Q values (rew and pun)
        Qr_chosen = Qr[choice[i, t]];
        Qp_chosen = Qp[choice[i, t]];

        // First, update Qr & Qp for all decks w/ fictive updating
        Qr += Arew[i] * PEr_fic;
        Qp += Apun[i] * PEp_fic;
        // Replace Q values of chosen deck with correct values using stored values
        Qr[choice[i, t]] = Qr_chosen + Arew[i] * PEr;
        Qp[choice[i, t]] = Qp_chosen + Apun[i] * PEp;

        // Q(sum)
        Qsum = Qr + Qp;
      }
    }
  }
}

