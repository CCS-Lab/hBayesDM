data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  int<lower=1,upper=2> choice[N, T];
  real rewlos[N, T];
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
  vector[N] Apun_pr;   # learning rate (punishment)
  vector[N] Arew_pr;   # learning rate (reward)
  vector[N] beta_pr;   # inverse temperature
}

transformed parameters {
  # Transform subject-level raw parameters 
  vector<lower=0,upper=1>[N]  Apun;
  vector<lower=0,upper=1>[N]  Arew;
  vector<lower=0,upper=10>[N] beta;
        
  for (i in 1:N) {
    Apun[i]  = Phi_approx( mu_p[1] + sigma[1] * Apun_pr[i] );
    Arew[i]  = Phi_approx( mu_p[2] + sigma[2] * Arew_pr[i] );
    beta[i]  = Phi_approx( mu_p[3] + sigma[3] * beta_pr[i] ) * 10;
  }
}

model {
  # Hyperparameters
  mu_p  ~ normal(0, 1); 
  sigma ~ cauchy(0, 5);  
  
  # individual parameters
  Apun_pr ~ normal(0,1);
  Arew_pr ~ normal(0,1);
  beta_pr ~ normal(0,1);
    
  for (i in 1:N) {
    # Define Values
    vector[2] ev; # Expected value
    real PE; # prediction error
    
    # Initialize values    
    ev = initV; # initial ev values
        
    for (t in 1:(Tsubj[i]-1)) {
      # Prediction Error
      PE = rewlos[i,t] - ev[ choice[i,t]];
            
      # Update expected value of chosen stimulus
      ev[ choice[i,t]] = ev[ choice[i,t]] + (Apun[i] * (1-rewlos[i,t])) * PE + (Arew[i] * (rewlos[i,t])) * PE;
          
      # Softmax choice
      choice[i, t+1] ~ categorical_logit( ev * beta[i] );
    }
  }
}

generated quantities {
  # For group level parameters 
  real<lower=0,upper=1>  mu_Apun;
  real<lower=0,upper=1>  mu_Arew;
  real<lower=0,upper=10> mu_beta;
  
  # For log likelihood calculation
  real log_lik[N];

  mu_Apun = Phi_approx(mu_p[1]);
  mu_Arew = Phi_approx(mu_p[2]);
  mu_beta = Phi_approx(mu_p[3]) * 10;
    
  { # local section, this saves time and space
    for (i in 1:N) {
      # Define values
      vector[2] ev; # Expected value
      real PE; # prediction error
      
      # Initialize values      
      ev = initV; # initial ev values
      log_lik[i] = 0;
            
      for (t in 1:(Tsubj[i]-1)) {
        # Prediction Error
        PE = rewlos[i,t] - ev[ choice[i,t]];
                
        # Update expected value of chosen stimulus
        ev[ choice[i,t]] = ev[ choice[i,t]] + (Apun[i] * (1-rewlos[i,t])) * PE + (Arew[i] * (rewlos[i,t])) * PE;
                
        # Softmax choice
        log_lik[i] = log_lik[i] + categorical_logit_lpmf( choice[i, t+1] | ev * beta[i]);
      }
    }
  }
}
