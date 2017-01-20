data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  real offer[N, T];
  int<lower=0, upper=1> accept[N, T];
}
transformed data {
  real initV;
  real mu0;
  real k0;
  real sig20;
  real nu0;
  
  initV   = 0.0;   
  mu0     = 10.0;  # initial expectation                                                        
  k0      = 4.0;                                                          
  sig20   = 4.0;                                         
  nu0     = 10.0;   
}
parameters {
# Declare all parameters as vectors for vectorizing
  # Hyper(group)-parameters  
  vector[3] mu_p;  
  vector<lower=0>[3] sigma;
      
  # Subject-level raw parameters (for Matt trick)
  vector[N] alpha_pr; # alpha: envy
  vector[N] Beta_pr;  # Beta: guilt. Use a capital letter B because of built-in 'beta'
  vector[N] tau_pr;   # tau: inverse temperature
}
transformed parameters {
  # Transform subject-level raw parameters 
  real<lower=0,upper=20> alpha[N]; 
  real<lower=0,upper=10> Beta[N];   
  real<lower=0,upper=10> tau[N];  

  for (i in 1:N) {
    alpha[i] = Phi_approx( mu_p[1] + sigma[1] * alpha_pr[i] ) * 20;
    Beta[i]  = Phi_approx( mu_p[2] + sigma[2]  * Beta_pr[i] ) * 10;
    tau[i]   = Phi_approx( mu_p[3] + sigma[3]   * tau_pr[i] ) * 10;
  }
}
model {
  # Hyperparameters
  mu_p  ~ normal(0, 1); 
  sigma ~ cauchy(0, 5);  
  
  # individual parameters
  alpha_pr ~ normal(0, 1.0);   
  Beta_pr  ~ normal(0, 1.0);   
  tau_pr   ~ normal(0, 1.0); 
  
  for (i in 1:N) {
    # Define values
    real util;
    real mu_old; 
    real mu_new;
    real k_old;
    real k_new;
    real sig2_old;
    real sig2_new;
    real nu_old;
    real nu_new;
    real PE;  # not required for computation
    
    # Initialize values
    mu_old   = mu0;
    k_old    = k0;
    sig2_old = sig20;
    nu_old   = nu0;

    for (t in 1:Tsubj[i]) {
      k_new    = k_old + 1;
      nu_new   = nu_old + 1;
      mu_new   = (k_old/k_new)*mu_old + (1/k_new)*offer[i,t];
      sig2_new = (nu_old/nu_new)*sig2_old + (1/nu_new)*(k_old/k_new)*pow( (offer[i,t] - mu_old), 2);

      PE   = offer[i,t] - mu_old; 
      util = offer[i,t] - alpha[i] * fmax(mu_new - offer[i,t], 0.0) - Beta[i] * fmax(offer[i,t] - mu_new, 0.0);

      accept[i, t] ~ bernoulli_logit( util * tau[i] ); 

      # replace old ones with new ones
      mu_old   = mu_new;
      sig2_old = sig2_new;
      k_old    = k_new;
      nu_old   = nu_new;
    } # end of t loop
  } # end of i loop 
}
generated quantities {
  # For group level parameters 
  real<lower=0,upper=20> mu_alpha;
  real<lower=0,upper=10> mu_Beta;  
  real<lower=0,upper=10> mu_tau;
  
  # For log likelihood calculation
  real log_lik[N];
  
  mu_alpha = Phi_approx(mu_p[1]) * 20;
  mu_Beta  = Phi_approx(mu_p[2]) * 10; 
  mu_tau   = Phi_approx(mu_p[3]) * 10;  
  
  { # local section, this saves time and space
    for (i in 1:N) {
      # Define values
      real util;
      real mu_old; 
      real mu_new;
      real k_old;
      real k_new;
      real sig2_old;
      real sig2_new;
      real nu_old;
      real nu_new;
      real PE;  # not required for computation
      
      # Initialize values
      mu_old   = mu0;
      k_old    = k0;
      sig2_old = sig20;
      nu_old   = nu0;
  
      log_lik[i] = 0;
  
      for (t in 1:Tsubj[i]) {
        k_new    = k_old + 1;
        nu_new   = nu_old + 1;
        mu_new   = (k_old/k_new)*mu_old + (1/k_new)*offer[i,t];
        sig2_new = (nu_old/nu_new)*sig2_old + (1/nu_new)*(k_old/k_new)*pow( (offer[i,t] - mu_old), 2);
  
        PE   = offer[i,t] - mu_old; 
        util = offer[i,t] - alpha[i] * fmax(mu_new - offer[i,t], 0.0) - Beta[i] * fmax(offer[i,t] - mu_new, 0.0);
        
        log_lik[i] = log_lik[i] + bernoulli_logit_lpmf( accept[i,t] | util * tau[i] );
        
        # replace old ones with new ones
        mu_old   = mu_new;
        sig2_old = sig2_new;
        k_old    = k_new;
        nu_old   = nu_new;
      } # end of t loop 
    } # end of i loop
  } # end of local section
} 
