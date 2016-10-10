data {
    int<lower=1> N;
    int<lower=1> T;
    int<lower=1, upper=T> Tsubj[N];
    real<lower=0> delay_later[N,T];
    real<lower=0> amount_later[N,T];
    real<lower=0> delay_sooner[N,T];
    real<lower=0> amount_sooner[N,T];
    int<lower=0,upper=1> choice[N, T]; # 0 for instant reward, 1 for delayed reward
}
transformed data {
}
parameters {
# Declare all parameters as vectors for vectorizing
  # Hyper(group)-parameters  
  vector[3] mu_p;  
  vector<lower=0>[3] sigma;
      
  # Subject-level raw parameters (for Matt trick)
  vector[N] r_pr;     # (exponential) discounting rate
  vector[N] s_pr;     # impatience
  vector[N] beta_pr;  # inverse temperature
}
transformed parameters {
  # Transform subject-level raw parameters 
  vector<lower=0,upper=1>[N]  r;
  vector<lower=0,upper=10>[N] s;
  vector<lower=0,upper=5>[N]  beta;
        
  for (i in 1:N) {
    r[i]    = Phi_approx( mu_p[1] + sigma[1] * r_pr[i] );
    s[i]    = Phi_approx( mu_p[2] + sigma[2] * s_pr[i] ) * 10;
    beta[i] = Phi_approx( mu_p[3] + sigma[3] * beta_pr[i] ) * 5;
  }
}
model {
# Constant-sensitivity model (Ebert & Prelec, 2007)
  # Hyperparameters
  mu_p  ~ normal(0, 1); 
  sigma ~ cauchy(0, 5);  
  
  # individual parameters
  r_pr    ~ normal(0, 1);
  s_pr    ~ normal(0, 1);
  beta_pr ~ normal(0, 1);
    
  for (i in 1:N) {
    # Define values
    real ev_later;
    real ev_sooner;
        
    for (t in 1:(Tsubj[i])) {
      ev_later  = amount_later[i,t] * exp(-1* ( pow(r[i] * delay_later[i,t], s[i]) ) ); 
      ev_sooner = amount_sooner[i,t] * exp(-1* ( pow(r[i] * delay_sooner[i,t], s[i]) ) ); 
      choice[i,t] ~ bernoulli_logit( beta[i] * (ev_later - ev_sooner) );
    }
  }
}

generated quantities {
  # For group level parameters 
  real<lower=0,upper=1>  mu_r;
  real<lower=0,upper=10> mu_s;
  real<lower=0,upper=5>  mu_beta;
  
  # For log likelihood calculation
  real log_lik[N];

  mu_r    = Phi_approx(mu_p[1]);
  mu_s    = Phi_approx(mu_p[2]) * 10;
  mu_beta = Phi_approx(mu_p[3]) * 5;
  
  { # local section, this saves time and space
    for (i in 1:N) {
      # Define values
      real ev_later;
      real ev_sooner;
          
      log_lik[i] = 0;
        
      for (t in 1:(Tsubj[i])) {
        ev_later  = amount_later[i,t] * exp(-1* ( pow(r[i] * delay_later[i,t], s[i]) ) ); 
        ev_sooner = amount_sooner[i,t] * exp(-1* ( pow(r[i] * delay_sooner[i,t], s[i]) ) ); 
        log_lik[i] = log_lik[i] + bernoulli_logit_lpmf( choice[i,t] | beta[i] * (ev_later - ev_sooner) );
      }
    }
  }
}
