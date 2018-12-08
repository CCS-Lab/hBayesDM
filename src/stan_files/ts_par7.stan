#include /pre/license.stan

data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  int<lower=1, upper=2> level1_choice[N,T];  // 1: left, 2: right
  int<lower=1, upper=4> level2_choice[N,T];  // 1-4: 1/2: commonly associated with level1=1, 3/4: commonly associated with level1=2
  int<lower=0, upper=1> reward[N,T];
  real<lower=0, upper=1> trans_prob;
}
transformed data {
}
parameters {
  // Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[7] mu_pr;
  vector<lower=0>[7] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] a1_pr;
  vector[N] beta1_pr;
  vector[N] a2_pr;
  vector[N] beta2_pr;
  vector[N] pi_pr;
  vector[N] w_pr;
  vector[N] lambda_pr;
}
transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0,upper=1>[N] a1;
  vector<lower=0>[N]         beta1;
  vector<lower=0,upper=1>[N] a2;
  vector<lower=0>[N]         beta2;
  vector<lower=0,upper=5>[N] pi;
  vector<lower=0,upper=1>[N] w;
  vector<lower=0,upper=1>[N] lambda;

  for (i in 1:N) {
      a1[i]     = Phi_approx( mu_pr[1] + sigma[1] * a1_pr[i] );
      beta1[i]  = exp( mu_pr[2] + sigma[2] * beta1_pr[i] );
      a2[i]     = Phi_approx( mu_pr[3] + sigma[3] * a2_pr[i] );
      beta2[i]  = exp( mu_pr[4] + sigma[4] * beta2_pr[i] );
      pi[i]     = Phi_approx( mu_pr[5] + sigma[5] * pi_pr[i] ) * 5;
      w[i]      = Phi_approx( mu_pr[6] + sigma[6] * w_pr[i] );
      lambda[i] = Phi_approx( mu_pr[7] + sigma[7] * lambda_pr[i] );
  }
}
model {
  // Hyperparameters
  mu_pr  ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // individual parameters
  a1_pr     ~ normal(0, 1);
  beta1_pr  ~ normal(0, 1);
  a2_pr     ~ normal(0, 1);
  beta2_pr  ~ normal(0, 1);
  pi_pr     ~ normal(0, 1);
  w_pr      ~ normal(0, 1);
  lambda_pr ~ normal(0, 1);

  for (i in 1:N) {
    // Define values
    vector[2] v_mb;    // model-based stimulus values for level 1 (2 stimuli)
    vector[6] v_mf;    // model-free stimulus values for level 1&2 (1,2--> level 1, 3-6--> level 2)
    vector[2] v_hybrid;  // hybrid stimulus values for level 1 (2 stimuli)
    real level1_prob_choice2; // Initialize prob. of choosing stim 2 (0 or 1) in level 1
    real level2_prob_choice2; // Initialize prob. of choosing stim 2 (0 or 1) in level 2
    int level1_choice_01;
    int level2_choice_01;

    // Initialize values
    v_mb  = rep_vector(0.0, 2);
    v_mf  = rep_vector(0.0, 6);
    v_hybrid = rep_vector(0.0, 2);

    for (t in 1:Tsubj[i])  {
      // compute v_mb
      v_mb[1] = trans_prob * fmax(v_mf[3], v_mf[4]) + (1 - trans_prob) * fmax(v_mf[5], v_mf[6]); // for level1, stim 1
      v_mb[2] = (1 - trans_prob) * fmax(v_mf[3], v_mf[4]) + trans_prob * fmax(v_mf[5], v_mf[6]); // for level1, stim 2

      // compute v_hybrid
      v_hybrid[1] = w[i] * v_mb[1] + (1-w[i]) * v_mf[1];   // hybrid stim 1= weighted sum
      v_hybrid[2] = w[i] * v_mb[2] + (1-w[i]) * v_mf[2];   // hybrid stim 2= weighted sum

      // Prob of choosing stimulus 2 in ** Level 1 ** --> to be used on the next trial
      // level1_choice=1 --> -1, level1_choice=2 --> 1
      level1_choice_01 = level1_choice[i,t] - 1;  // convert 1,2 --> 0,1
      if(t == 1){
        level1_prob_choice2 = inv_logit( beta1[i]*(v_hybrid[2]-v_hybrid[1]));
      } else{
        level1_prob_choice2 = inv_logit( beta1[i]*(v_hybrid[2]-v_hybrid[1]) + pi[i]*(2*level1_choice[i,t-1] -3) );
      }
      level1_choice_01 ~ bernoulli( level1_prob_choice2 );  // level 1, prob. of choosing 2 in level 1

      // Observe Level2 and update Level1 of the chosen option
      v_mf[level1_choice[i,t]] += a1[i]*(v_mf[2+ level2_choice[i,t]] - v_mf[ level1_choice[i,t]]);

      // Prob of choosing stim 2 (2 from [1,2] OR 4 from [3,4]) in ** Level (step) 2 **
      level2_choice_01 = 1 - modulus(level2_choice[i,t], 2); // 1,3 --> 0; 2,4 --> 1
      if (level2_choice[i,t] > 2) {  // level2_choice = 3 or 4
        level2_prob_choice2 = inv_logit( beta2[i]*( v_mf[6] - v_mf[5] ) );
      } else { // level2_choice = 1 or 2
        level2_prob_choice2 = inv_logit( beta2[i]*( v_mf[4] - v_mf[3] ) );
      }
       level2_choice_01 ~ bernoulli( level2_prob_choice2 );   // level 2, prob of choosing right option in level 2

      // After observing the reward at Level 2...
      // Update Level 2 v_mf of the chosen option. Level 2--> choose one of level 2 options and observe reward
      v_mf[2+ level2_choice[i,t]] += a2[i]*(reward[i,t] - v_mf[2+ level2_choice[i,t] ] );

      // Update Level 1 v_mf
      v_mf[level1_choice[i,t]] += lambda[i] * a1[i] * (reward[i,t] - v_mf[2+level2_choice[i,t]]);
    } // end of t loop
  } // end of i loop
}

generated quantities {
  // For group level parameters
  real<lower=0,upper=1> mu_a1;
  real<lower=0>         mu_beta1;
  real<lower=0,upper=1> mu_a2;
  real<lower=0>         mu_beta2;
  real<lower=0,upper=5> mu_pi;
  real<lower=0,upper=1> mu_w;
  real<lower=0,upper=1> mu_lambda;

  // For log likelihood calculation
  real log_lik[N];

  // For posterior predictive check
  real y_pred_step1[N,T];
  real y_pred_step2[N,T];

  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      y_pred_step1[i,t] = -1;
      y_pred_step2[i,t] = -1;
    }
  }

  // Generate group level parameter values
  mu_a1     = Phi_approx( mu_pr[1] );
  mu_beta1  = exp( mu_pr[2] );
  mu_a2     = Phi_approx( mu_pr[3] );
  mu_beta2  = exp( mu_pr[4] );
  mu_pi     = Phi_approx( mu_pr[5] ) * 5;
  mu_w      = Phi_approx( mu_pr[6] );
  mu_lambda = Phi_approx( mu_pr[7] );

  { // local section, this saves time and space
  for (i in 1:N) {
    // Define values
    vector[2] v_mb;    // model-based stimulus values for level 1 (2 stimuli)
    vector[6] v_mf;    // model-free stimulus values for level 1&2 (1,2--> level 1, 3-6--> level 2)
    vector[2] v_hybrid;  // hybrid stimulus values for level 1 (2 stimuli)
    real level1_prob_choice2; // prob of choosing stim 2 (0 or 1) in level 1
    real level2_prob_choice2; // prob of choosing stim 2 (0 or 1) in level 2
    int level1_choice_01;
    int level2_choice_01;

    // Initialize values
    v_mb  = rep_vector(0.0, 2);
    v_mf  = rep_vector(0.0, 6);
    v_hybrid = rep_vector(0.0, 2);

    log_lik[i] = 0;

    for (t in 1:Tsubj[i])  {
      // compute v_mb
      v_mb[1] = trans_prob * fmax(v_mf[3], v_mf[4]) + (1 - trans_prob) * fmax(v_mf[5], v_mf[6]); // for level1, stim 1
      v_mb[2] = (1 - trans_prob) * fmax(v_mf[3], v_mf[4]) + trans_prob * fmax(v_mf[5], v_mf[6]); // for level1, stim 2

      // compute v_hybrid
      v_hybrid[1] = w[i] * v_mb[1] + (1-w[i]) * v_mf[1];   // hybrid stim 1= weighted sum
      v_hybrid[2] = w[i] * v_mb[2] + (1-w[i]) * v_mf[2];   // hybrid stim 2= weighted sum

      // Prob of choosing stimulus 2 in ** Level 1 ** --> to be used on the next trial
      // level1_choice=1 --> -1, level1_choice=2 --> 1
      level1_choice_01 = level1_choice[i,t] - 1;  // convert 1,2 --> 0,1
      if(t == 1){
        level1_prob_choice2 = inv_logit( beta1[i]*(v_hybrid[2]-v_hybrid[1]));
      } else{
        level1_prob_choice2 = inv_logit( beta1[i]*(v_hybrid[2]-v_hybrid[1]) + pi[i]*(2*level1_choice[i,t-1] -3) );
      }
      log_lik[i] += bernoulli_lpmf( level1_choice_01 | level1_prob_choice2 );

      // Observe Level2 and update Level1 of the chosen option
      v_mf[level1_choice[i,t]] += a1[i]*(v_mf[2+ level2_choice[i,t]] - v_mf[ level1_choice[i,t]]);

      // Prob of choosing stim 2 (2 from [1,2] OR 4 from [3,4]) in ** Level (step) 2 **
      level2_choice_01 = 1 - modulus(level2_choice[i,t], 2); // 1,3 --> 0; 2,4
      // Level 2 --> choose one of two level 2 options
      if (level2_choice[i,t] > 2) {  // level2_choice = 3 or 4
        level2_prob_choice2 = inv_logit( beta2[i]*( v_mf[6] - v_mf[5] ) );
      } else { // level2_choice = 1 or 2
        level2_prob_choice2 = inv_logit( beta2[i]*( v_mf[4] - v_mf[3] ) );
      }
      log_lik[i] += bernoulli_lpmf( level2_choice_01 | level2_prob_choice2 );

      // generate posterior prediction for current trial
      y_pred_step1[i,t] = bernoulli_rng(level1_prob_choice2);
      y_pred_step2[i,t] = bernoulli_rng(level2_prob_choice2);

      // After observing the reward at Level 2...
      // Update Level 2 v_mf of the chosen option. Level 2--> choose one of level 2 options and observe reward
      v_mf[2+ level2_choice[i,t]] += a2[i]*(reward[i,t] - v_mf[2+ level2_choice[i,t] ] );

      // Update Level 1 v_mf
      v_mf[level1_choice[i,t]] += lambda[i] * a1[i] * (reward[i,t] - v_mf[2+level2_choice[i,t]]);
      } // end of t loop
    } // end of i loop
  }
}

