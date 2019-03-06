#include /pre/license.stan

data {
#include /data/wcs_sql.stan
}

transformed data {
#include /tdata/wcs_sql.stan
}

parameters {
  // hyper parameters
#include /param/hyperparam-3.stan

  // subject-level raw parameters (for Matt trick)
  vector[N] r_pr; // sensitivity to rewarding feedback (reward learning rate)
  vector[N] p_pr; // sensitivity to punishing feedback (punishment learning rate)
  vector[N] d_pr; // decision consistency (inverse temperature)
}

transformed parameters {
  // transform subject-level raw parameters
  vector<lower=0,upper=1>[N] r;
  vector<lower=0,upper=1>[N] p;
  vector<lower=0,upper=5>[N] d;

  r = Phi_approx(mu_pr[1] + sigma[1] * r_pr);
  p = Phi_approx(mu_pr[2] + sigma[2] * p_pr);
  d = Phi_approx(mu_pr[3] + sigma[3] * d_pr) * 5;
}

model {
  // hyperparameters
  mu_pr ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // individual parameters
  r_pr ~ normal(0, 1);
  p_pr ~ normal(0, 1);
  d_pr ~ normal(0, 1);

  for (i in 1:N) {
    // define values
    vector[4] p_choice;     // predicted probability of choosing a deck in each trial based on attention
    vector[3] att;          // subject's attention to each dimension
    vector[3] sig;          // signal where a subject has to pay attention after reward/punishment

    vector[3] tmp;       // temporary variable to calculate att
    vector[3] match_chosen;
    real rp;

    // initiate values
    att = init_att;

    for (t in 1:Tsubj[i]) {
      tmp[1] = pow(att[1], d[i]);
      tmp[2] = pow(att[2], d[i]);
      tmp[3] = pow(att[3], d[i]);

      // Calculate p_choice in the given trial
      p_choice = to_vector(tmp' * match[t]);
      p_choice /= sum(p_choice);

      // Categorical choice
      choice[i, t] ~ categorical(p_choice);

      // re-distribute attention after getting a feedback
      match_chosen = match[t, :, choice[i, t]];
      sig = (outcome[i, t] == 1) ? match_chosen : 1 - match_chosen;
      sig /= sum(sig);

      rp = (outcome[i, t] == 1) ? r[i] : p[i];
      tmp = (1 - rp) * att + rp * sig;
      att = tmp / sum(tmp);
    } // end of trial loop
  } // end of subject loop
}

generated quantities {
  // for group level parameters
  real<lower=0, upper=1> mu_r;
  real<lower=0, upper=1> mu_p;
  real<lower=0, upper=5> mu_d;

  // for log-likelihood calculation
  real log_lik[N];

  // for posterior predictive check
  int y_pred[N, T];

  // initiate the variable to avoid NULL values
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred[i, t] = -1;
    }
  }

  mu_r = Phi_approx(mu_pr[1]);
  mu_p = Phi_approx(mu_pr[2]);
  mu_d = Phi_approx(mu_pr[3]) * 5;

  { // local section, this saves time and space
    for (i in 1:N) {
      // define values
      vector[4] p_choice;  // predicted probability of choosing a deck in each trial based on attention
      vector[3] att;    // subject's attention to each dimension
      vector[3] sig;  // signal where a subject has to pay attention after reward/punishment

      vector[3] tmp;      // temporary variable to calculate att
      vector[3] match_chosen;
      real rp;

      // initiate values
      att = init_att;
      log_lik[i] = 0;

      for (t in 1:Tsubj[i]) {
        tmp[1] = pow(att[1], d[i]);
        tmp[2] = pow(att[2], d[i]);
        tmp[3] = pow(att[3], d[i]);

        // Calculate p_choice in the given trial
        p_choice = to_vector(tmp' * match[t]);
        p_choice /= sum(p_choice);

        // Categorical choice
        log_lik[i] += categorical_lpmf(choice[i, t] | p_choice);
        y_pred[i, t] = categorical_rng(p_choice);

        // re-distribute attention after getting a feedback
        match_chosen = match[t, :, choice[i, t]];
        sig = (outcome[i, t] == 1) ? match_chosen : 1 - match_chosen;
        sig /= sum(sig);

        rp = (outcome[i, t] == 1) ? r[i] : p[i];
        tmp = (1 - rp) * att + rp * sig;
        att = tmp / sum(tmp);
      } // end of trial loop
    } // end of subject loop
  }
}

