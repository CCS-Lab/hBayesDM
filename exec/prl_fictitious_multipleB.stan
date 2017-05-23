data {
  int<lower=1> N;                          # Number of subjects
  int<lower=0> T;                          # Max number of trials across subjects
  int<lower=1> maxB;                       # Max number of blocks across subjects
  int<lower=1> B[N];                       # Number of blocks for each subject 
  int<lower=0, upper=T> Tsubj[N, maxB];    # Number of trials/block for each subject
  int<lower=1,upper=2> choice[N, maxB, T]; # Choice for each subject-block-trial
  real outcome[N, maxB, T];                 # Outcome (reward/loss) for each subject-block-trial
}
transformed data {
  vector[2] initV;
  initV = rep_vector(0.0, 2);
}
parameters {
# Declare all parameters as vectors for vectorizing
  # Hyper(group)-parameters  
  vector[3] mu_p;  
  vector<lower=0>[3] sigma;
    
  # Subject-level raw parameters (for Matt trick)
  vector[N] eta_pr;   # learning rate
  vector[N] alpha_pr; # indecision point
  vector[N] beta_pr;  # inverse temperature
}

transformed parameters {
  # Transform subject-level raw parameters
  vector<lower=0,upper=1>[N] eta;
  vector<lower=0,upper=1>[N] alpha;
  vector<lower=0,upper=10>[N] beta;
        
  for (i in 1:N) {
    eta[i]    = Phi_approx( mu_p[1] + sigma[1] * eta_pr[i] );
    alpha[i]  = Phi_approx( mu_p[2] + sigma[2] * alpha_pr[i] );
    beta[i]   = Phi_approx( mu_p[3] + sigma[3] * beta_pr[i] ) * 10;
  }
}

model {
  # Hyperparameters
  mu_p  ~ normal(0, 1);
  sigma ~ cauchy(0, 5);
  
  # individual parameters
  eta_pr    ~ normal(0,1);
  alpha_pr  ~ normal(0,1);
  beta_pr   ~ normal(0,1);
    
  for (i in 1:N) {
    for (bIdx in 1:B[i]) {  # new
      # Define values
      vector[2] ev;
      vector[2] prob;
      real PE;     # prediction error
      real PEnc;   # fictitious prediction error (PE-non-chosen)
      
      # Initialize values
      ev = initV; # initial ev values
          
      for (t in 1:(Tsubj[i, bIdx])) {  # new
        # compute action probabilities
        prob[1] = 1 / (1 + exp( beta[i] * (alpha[i] - (ev[1] - ev[2])) ));
        prob[2] = 1 - prob[1];
        choice[i,bIdx,t] ~ categorical( prob );
        #choice[i,t] ~ bernoulli( prob );
  
        # prediction error
        PE   =  outcome[i,bIdx,t] - ev[choice[i,bIdx,t]];  #new
        PEnc = -outcome[i,bIdx,t] - ev[3-choice[i,bIdx,t]];  #new
  
        # value updating (learning)
        ev[choice[i,bIdx,t]]   = ev[choice[i,bIdx,t]]   + eta[i] * PE;   #new
        ev[3-choice[i,bIdx,t]] = ev[3-choice[i,bIdx,t]] + eta[i] * PEnc;  #new
      } # end of t loop
    } # end of bIdx loop
  } # end of i loop
}

generated quantities {
  # For group level parameters
  real<lower=0,upper=1> mu_eta;
  real<lower=0,upper=1> mu_alpha;
  real<lower=0,upper=10> mu_beta;
  
  # For log likelihood calculation
  real log_lik[N];

  mu_eta    = Phi_approx(mu_p[1]);
  mu_alpha  = Phi_approx(mu_p[2]);
  mu_beta   = Phi_approx(mu_p[3]) * 10;
    
  { # local section, this saves time and space
    for (i in 1:N) {
      
      log_lik[i] = 0;
      
      for (bIdx in 1:B[i]) {
        # Define values
        vector[2] ev;
        vector[2] prob;
        real PE;     # prediction error
        real PEnc;   # fictitious prediction error (PE-non-chosen)
      
        # Initialize values
        ev = initV; # initial ev values
              
        for (t in 1:(Tsubj[i, bIdx])) {
          # compute action probabilities
          prob[1] = 1 / (1 + exp( beta[i] * (alpha[i] - (ev[1] - ev[2])) ));
          prob[2] = 1 - prob[1];
  
          log_lik[i] = log_lik[i] + categorical_lpmf( choice[i, bIdx, t] | prob );  #new
          #log_lik[i] = log_lik[i] + bernoulli_lpmf( choice[i, bIdx, t] | prob );  #new
  
          # prediction error
          PE   =  outcome[i,bIdx,t] - ev[choice[i,bIdx,t]];  #new
          PEnc = -outcome[i,bIdx,t] - ev[3-choice[i,bIdx,t]];  #new
  
          # value updating (learning)
          ev[choice[i,bIdx,t]]   = ev[choice[i,bIdx,t]]   + eta[i] * PE;   #new
          ev[3-choice[i,bIdx,t]] = ev[3-choice[i,bIdx,t]] + eta[i] * PEnc;  #new
        } # end of t loop
      } # end of bIdx loop
    }
  }
}
