data {
  int<lower=1> N;                                       // number of subjects
  int<lower=1> T;                                       // max trial
  int<lower=40, upper=T> Tsubj[N];                      // number of max trials per subject

  int<lower=0, upper=4> choice[N, 4, T];                // subject's deck choice within a trial (1, 2, 3 and 4)
  int<lower=-1, upper=1> outcome[N, T];                 // whether subject's choice is correct or not within a trial (1 and 0)
  matrix<lower=0, upper=1>[1, 3] choice_match_att[N, T]; // indicates which dimension the chosen card matches to within a trial
  matrix<lower=0, upper=1>[3, 4] deck_match_rule[T];     // indicates which dimension(color, form, number) each of the 4 decks matches to within a trial
}

transformed data {
  matrix[1, 3] initAtt; // each subject start with an even attention to each dimension
  matrix[1, 3] unit;    // used to flip attention after punishing feedback insde the model

  initAtt = rep_matrix(1.0/3.0, 1, 3);
  unit = rep_matrix(1.0, 1, 3);
}

parameters {
  // hyper parameters
  vector[3] mu_pr;
  vector<lower=0>[3] sigma;

  // subject-level raw parameters (for Matt trick)
  vector[N] r_pr; // sensitivity to rewarding feedback (reward learning rate)
  vector[N] p_pr; // sensitivity to punishing feedback (punishment learning rate)
  vector[N] d_pr; // decision consistency (inverse temperature)
}

transformed parameters {
  // transform subject-level raw parameters
  vector<lower=0,upper=1>[N] r;
  vector<lower=0,upper=1>[N] p;
  vector<lower=0>[N] d;

  for (i in 1:N) {
    r[i] = Phi_approx( mu_pr[1] + sigma[1] * r_pr[i] );
    p[i] = Phi_approx( mu_pr[2] + sigma[2] * p_pr[i] );
    d[i] = Phi_approx( mu_pr[3] + sigma[3] * d_pr[i] ) * 5;
  }
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
    vector[4] pred_prob_mat;  // predicted probability of choosing a deck in each trial based on attention
    matrix[1, 3] subj_att;     // subject's attention to each dimension
    matrix[1, 3] att_signal;    // signal where a subject has to pay attention after reward/punishment
    matrix[1, 3] tmpatt;       // temporary variable to calculate subj_att
    vector[4] tmpp;           // temporary variable to calculate pred_prob_mat

    // initiate values
    subj_att = initAtt;
    pred_prob_mat = to_vector(subj_att*deck_match_rule[1,,]);

    for (t in 1:Tsubj[i]) {
      // multinomial choice
      choice[i,,t] ~ multinomial(pred_prob_mat);

      // re-distribute attention after getting a feedback
      if (outcome[i,t] == 1) {
        att_signal = subj_att .* choice_match_att[i,t];
        att_signal = att_signal/sum(att_signal);
        tmpatt = (1.0 - r[i])*subj_att + r[i]*att_signal;
      } else {
        att_signal = subj_att .* (unit - choice_match_att[i,t]);
        att_signal = att_signal/sum(att_signal);
        tmpatt = (1.0 - p[i])*subj_att + p[i]*att_signal;
      }

      // scaling to avoide log(0)
      subj_att = (tmpatt/sum(tmpatt))*.9998+.0001;

      tmpatt[1, 1] = pow(subj_att[1, 1],d[i]);
      tmpatt[1, 2] = pow(subj_att[1, 2],d[i]);
      tmpatt[1, 3] = pow(subj_att[1, 3],d[i]);

      // repeat until the final trial
      if (t < Tsubj[i]) {
        tmpp = to_vector(tmpatt*deck_match_rule[t+1,,])*.9998+.0001;
        pred_prob_mat = tmpp/sum(tmpp);
      }

    } // end of trial loop
  } // end of subject loop
}
generated quantities {
  // for group level parameters
  real<lower=0, upper=1> mu_r;
  real<lower=0, upper=5> mu_p;
  real<lower=0, upper=5> mu_d;

  // for log-likelihood calculation
  real log_lik[N];

  // for posterior predictive check
  int y_pred[N, 4, T];

  // initiate the variable to avoid NULL values
  for (i in 1:N) {
    for (t in 1:T) {
      for (deck in 1:4) {
        y_pred[i,deck,t] = -1;
      }
    }
  }

  mu_r = Phi_approx(mu_pr[1]);
  mu_p = Phi_approx(mu_pr[2]);
  mu_d = Phi_approx(mu_pr[3]) * 5;

  { // local section, this saves time and space
    for (i in 1:N) {
      matrix[1, 3] subj_att;
      matrix[1, 3] att_signal;
      vector[4] pred_prob_mat;

      matrix[1, 3] tmpatt;
      vector[4] tmpp;

      subj_att = initAtt;
      pred_prob_mat = to_vector(subj_att*deck_match_rule[1,,]);

      log_lik[i] = 0;

      for (t in 1:Tsubj[i]) {

        log_lik[i] = log_lik[i] + multinomial_lpmf(choice[i,,t] | pred_prob_mat);

        y_pred[i,,t] = multinomial_rng(pred_prob_mat, 1);

        if(outcome[i,t] == 1) {
          att_signal = subj_att .* choice_match_att[i,t];
          att_signal = att_signal/sum(att_signal);
          tmpatt = (1.0 - r[i])*subj_att + r[i]*att_signal;
        } else {
          att_signal = subj_att .* (unit - choice_match_att[i,t]);
          att_signal = att_signal/sum(att_signal);
          tmpatt = (1.0 - p[i])*subj_att + p[i]*att_signal;
        }

        subj_att = (tmpatt/sum(tmpatt))*.9998+.0001;

        tmpatt[1, 1] = pow(subj_att[1, 1],d[i]);
        tmpatt[1, 2] = pow(subj_att[1, 2],d[i]);
        tmpatt[1, 3] = pow(subj_att[1, 3],d[i]);

        if(t < Tsubj[i]) {
          tmpp = to_vector(tmpatt*deck_match_rule[t+1,,])*.9998+.0001;
          pred_prob_mat = tmpp/sum(tmpp);
        }

      } // end of trial loop
    } // end of subject loop
  } // end of local section
}
