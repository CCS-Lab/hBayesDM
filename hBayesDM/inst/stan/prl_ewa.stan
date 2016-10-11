data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  int<lower=1,upper=2> choice[N, T];
  real rewlos[N, T];
}
transformed data {
  vector[2] init;
  init  = rep_vector(0.0, 2);
}
parameters {
# Declare all parameters as vectors for vectorizing
  # Hyper(group)-parameters  
  vector[3] mu_p;  
  vector<lower=0>[3] sigma;
      
  # Subject-level raw parameters (for Matt trick)
  vector[N] phi_pr;     # 1-learning rate
  vector[N] rho_pr;     # experience decay factor
  vector[N] beta_pr;    # inverse temperature
}

transformed parameters {
  # Transform subject-level raw parameters 
  vector<lower=0,upper=1>[N] phi;
  vector<lower=0,upper=1>[N] rho;
  vector<lower=0,upper=10>[N] beta;
        
  for (i in 1:N) {
    phi[i]  = Phi_approx( mu_p[1] + sigma[1] * phi_pr[i] );
    rho[i]  = Phi_approx( mu_p[2] + sigma[2] * rho_pr[i] );
    beta[i] = Phi_approx( mu_p[3] + sigma[3] * beta_pr[i] ) * 10;
  }
}

model {
  # Hyperparameters
  mu_p  ~ normal(0, 1); 
  sigma ~ cauchy(0, 5);  
  
  # individual parameters
  phi_pr  ~ normal(0,1);
  rho_pr  ~ normal(0,1);
  beta_pr ~ normal(0,1);
    
  for (i in 1:N) {
    # Define Values
    vector[2] ev; # Expected value
    vector[2] ew; # Experience weight
        
    real ewt1; # Experience weight (t-1)
    
    # Initialize values
    ev = init; # initial ev values
    ew = init; # initial ew values
        
    for (t in 1:(Tsubj[i]-1)) {
      # Store previous experience weight value
      ewt1 = ew[ choice[i,t]];
            
      # Update experience weight for chosen stimulus
      ew[ choice[i,t]] = ew[ choice[i,t]] * rho[i] + 1;
            
      # Update expected value of chosen stimulus
      ev[ choice[i,t]] = ( ev[ choice[i,t]] * phi[i] * ewt1 + rewlos[i,t] ) /  ew[ choice[i,t]];
            
      # Softmax choice
      choice[i, t+1] ~ categorical_logit( ev * beta[i] );
    }
  }
}

generated quantities {
  # For group level parameters 
  real<lower=0,upper=1> mu_phi;
  real<lower=0,upper=1> mu_rho;
  real<lower=-10,upper=10> mu_beta;
  
  # For log likelihood calculation
  real log_lik[N];

  mu_phi  = Phi_approx(mu_p[1]);
  mu_rho  = Phi_approx(mu_p[2]);
  mu_beta = Phi_approx(mu_p[3]) * 10;
    
  { # local section, this saves time and space
    for (i in 1:N) {
      # Define Values
      vector[2] ev; # Expected value
      vector[2] ew; # Experience weight
            
      real ewt1; # Experience weight (t-1)
      
      # Initialize Values
      ev = init; # initial ev values
      ew = init; # initial ew values
          
      log_lik[i] = 0;
            
      for (t in 1:(Tsubj[i]-1)) {
        # Store previous experience weight value
        ewt1 = ew[ choice[i,t]];
                
        # Update experience weight for chosen stimulus
        ew[ choice[i,t]] = ew[ choice[i,t]] * rho[i] + 1;
                
        # Update expected value of chosen stimulus
        ev[ choice[i,t]] = ( ev[ choice[i,t]] * phi[i] * ewt1 + rewlos[i,t] ) /  ew[ choice[i,t]];
                
        # Softmax choice
        log_lik[i] = log_lik[i] + categorical_logit_lpmf( choice[i, t+1] | ev * beta[i]);
      }
    }
  }
}
