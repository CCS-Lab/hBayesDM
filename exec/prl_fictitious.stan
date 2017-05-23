data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1,upper=T> Tsubj[N];
  int<lower=1,upper=2> choice[N, T];
  real outcome[N, T];
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
  vector<lower=0,upper=5>[N] beta;
        
  for (i in 1:N) {
    eta[i]   = Phi_approx( mu_p[1] + sigma[1] * eta_pr[i] );
    alpha[i] = Phi_approx( mu_p[2] + sigma[2] * alpha_pr[i] );
    beta[i]  = Phi_approx( mu_p[3] + sigma[3] * beta_pr[i] ) * 5;
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
    # Define values
    vector[2] ev;
    vector[2] prob;
    real PE;     # prediction error
    real PEnc;   # fictitious prediction error (PE-non-chosen)
    
    # Initialize values
    ev = initV; # initial ev values
        
    for (t in 1:(Tsubj[i])) {
      # compute action probabilities
      prob[1] = 1 / (1 + exp( beta[i] * (alpha[i] - (ev[1] - ev[2])) ));
      prob[2] = 1 - prob[1];
      choice[i,t] ~ categorical( prob );

      # prediction error
      PE   =  outcome[i,t] - ev[choice[i,t]];
      PEnc = -outcome[i,t] - ev[3-choice[i,t]];

      # value updating (learning)
      ev[choice[i,t]]   = ev[choice[i,t]]   + eta[i] * PE; 
      ev[3-choice[i,t]] = ev[3-choice[i,t]] + eta[i] * PEnc;
    }
  }
}

generated quantities {
  # For group level parameters
  real<lower=0,upper=1> mu_eta;
  real<lower=0,upper=1> mu_alpha;
  real<lower=0,upper=5> mu_beta;
  
  # For log likelihood calculation
  real log_lik[N];

  mu_eta    = Phi_approx(mu_p[1]);
  mu_alpha  = Phi_approx(mu_p[2]);
  mu_beta   = Phi_approx(mu_p[3]) * 5;
    
  { # local section, this saves time and space
    for (i in 1:N) {
      # Define values
      vector[2] ev;
      vector[2] prob;
      real PE;     # prediction error
      real PEnc;   # fictitious prediction error (PE-non-chosen)
    
      # Initialize values
      log_lik[i] = 0;
      ev = initV; # initial ev values
            
      for (t in 1:(Tsubj[i])) {
        # compute action probabilities
        prob[1] = 1 / (1 + exp( beta[i] * (alpha[i] - (ev[1] - ev[2])) ));
        prob[2] = 1 - prob[1];

        log_lik[i] = log_lik[i] + categorical_lpmf( choice[i, t] | prob );

        # prediction error
        PE   =  outcome[i,t] - ev[choice[i,t]];
        PEnc = -outcome[i,t] - ev[3-choice[i,t]];

        # value updating (learning)
        ev[choice[i,t]]   = ev[choice[i,t]]   + eta[i] * PE; 
        ev[3-choice[i,t]] = ev[3-choice[i,t]] + eta[i] * PEnc;
      }
    }
  }
}
