data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  real offer[N, T];
  int<lower=0, upper=1> accept[N, T];
}
transformed data {
}
parameters {
# Declare all parameters as vectors for vectorizing
  # Hyper(group)-parameters  
  vector[3] mu_p;  
  vector<lower=0>[3] sigma;
      
  # Subject-level raw parameters (for Matt trick)
  vector[N] ep_pr;     # ep: Norm adaptation rate
  vector[N] alpha_pr;  # alpha: Envy (sensitivity to norm prediction error)
  vector[N] tau_pr;    # tau: Inverse temperature 
}
transformed parameters {
  # Transform subject-level raw parameters 
  real<lower=0,upper=1> ep[N]; 
  real<lower=0,upper=20> alpha[N];  
  real<lower=0,upper=10> tau[N];   

  for (i in 1:N) {
    ep[i]    = Phi_approx( mu_p[1] + sigma[1] * ep_pr[i] );
    alpha[i] = Phi_approx( mu_p[3] + sigma[3] * alpha_pr[i] ) * 20;
    tau[i]   = Phi_approx( mu_p[2] + sigma[2] * tau_pr[i] ) * 10;
  }
}
model {
  # Hyperparameters
  mu_p  ~ normal(0, 1); 
  sigma ~ cauchy(0, 5);  
  
  # individual parameters
  ep_pr    ~ normal(0, 1.0);   
  alpha_pr ~ normal(0, 1.0);   
  tau_pr   ~ normal(0, 1.0);
  
  for (i in 1:N) {
    # Define values
    real f;    # Internal norm
    real PE;   # Prediction error
    real util; # Utility of offer
    
    # Initialize values
    f = 10.0;

    for (t in 1:Tsubj[i]) {
      # calculate prediction error
      PE = offer[i,t] - f;
      
      # Update utility
      util = offer[i,t] - alpha[i] * fmax(f - offer[i,t], 0.0); 
      
      # Sampling statement
      accept[i,t] ~ bernoulli_logit( util * tau[i] ); 
      
      # Update internal norm
      f = f + ep[i] * PE;
      
    } # end of t loop
  } # end of i loop 
}
generated quantities {
  # For group level parameters 
  real<lower=0,upper=1> mu_ep; 
  real<lower=0,upper=10> mu_tau;   
  real<lower=0,upper=20> mu_alpha;  
  
  # For log likelihood calculation
  real log_lik[N];
  
  mu_ep    = Phi_approx(mu_p[1]);
  mu_tau   = Phi_approx(mu_p[2]) * 10; 
  mu_alpha = Phi_approx(mu_p[3]) * 20;  
  
  { # local section, this saves time and space
    for (i in 1:N) {
      # Define values
      real f;    # Inernal norm
      real PE;   # prediction error
      real util; # Utility of offer
      
      # Initialize values
      f = 10.0;
      log_lik[i] = 0.0;
      
      for (t in 1:Tsubj[i]) {
        # calculate prediction error
        PE = offer[i,t] - f;
        
        # Update utility
        util = offer[i,t] - alpha[i] * fmax(f - offer[i,t], 0.0); 
        
        # Calculate log likelihood
        log_lik[i] = log_lik[i] + bernoulli_logit_lpmf( accept[i,t] | util * tau[i] );
        
        # Update internal norm
        f = f + ep[i] * PE;

      } # end of t loop 
    } # end of i loop
  } # end of local section
} 
