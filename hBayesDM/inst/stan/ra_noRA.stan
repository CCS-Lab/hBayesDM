data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  int<lower=0, upper=1> gamble[N,T];
  real<lower=0> gain[N,T];
  real cert[N,T];  
  real<lower=0> loss[N,T];  # absolute loss amount
}
transformed data {
}
parameters {
  vector[2] mu_p;  
  vector<lower=0>[2] sigma;  
  vector[N] lambda_p;  
  vector[N] tau_p;  
}
transformed parameters {
  vector<lower=0,upper=5>[N] lambda;
  vector<lower=0>[N] tau;
     
  for (i in 1:N) {
    lambda[i]  = 5 * Phi_approx( mu_p[1] + sigma[1] * lambda_p[i] );
    tau[i]     = 5 * Phi_approx( mu_p[2] + sigma[2] * tau_p[i] );
  }
}
model {
  # ra_prospect: Original model in Soko-Hessner et al 2009 PNAS
  # hyper parameters
  mu_p  ~ normal(0, 1.0); 
  sigma ~ cauchy(0, 5);
  
  # individual parameters w/ Matt trick
  lambda_p ~ normal(0, 1.0);   
  tau_p    ~ normal(0, 1.0);
  
  for (i in 1:N) {
    for (t in 1:Tsubj[i]) {
      real evSafe;    # evSafe, evGamble, pGamble can be a scalar to save memory and increase speed. 
      real evGamble;  # they are left as arrays as an example for RL models.
      real pGamble;
      
      # loss[i,t]=absolute amount of loss (pre-converted in R)
      evSafe   = cert[i,t];    
      evGamble = 0.5 * (gain[i,t] - lambda[i] * loss[i,t]);  
      pGamble  = inv_logit( tau[i] * (evGamble - evSafe) );
      gamble[i,t] ~ bernoulli( pGamble );
    }
  }
}

generated quantities {
  real<lower=0, upper=5> mu_lambda;
  real<lower=0, upper=5> mu_tau;
  real log_lik[N];

  mu_lambda = 5 * Phi(mu_p[1]);
  mu_tau    = 5 * Phi(mu_p[2]);

  { # local section, this saves time and space
    for (i in 1:N) {
      log_lik[i] = 0;
      for (t in 1:Tsubj[i]) {
        real evSafe;    # evSafe, evGamble, pGamble can be a scalar to save memory and increase speed. 
        real evGamble;  # they are left as arrays as an example for RL models.
        real pGamble;
        
        evSafe   = cert[i,t];
        evGamble = 0.5 * (gain[i,t] - lambda[i] * loss[i,t]);  
        pGamble    = inv_logit( tau[i] * (evGamble - evSafe) );
        log_lik[i] = log_lik[i] + bernoulli_lpmf( gamble[i,t] | pGamble );
      }
    }
  }
}
