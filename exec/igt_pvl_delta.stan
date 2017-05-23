data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1,upper=T> Tsubj[N];
  real outcome[N, T];
  int choice[N, T];
}

transformed data {
  vector[4] initV;
  initV  = rep_vector(0.0,4);
}

parameters {
# Declare all parameters as vectors for vectorizing
  # Hyper(group)-parameters  
  vector[4] mu_p;  
  vector<lower=0>[4] sigma;
    
  # Subject-level raw parameters (for Matt trick)
  vector[N] A_pr;
  vector[N] alpha_pr;
  vector[N] cons_pr;
  vector[N] lambda_pr;
}

transformed parameters {
  # Transform subject-level raw parameters 
  vector<lower=0,upper=1>[N]  A;
  vector<lower=0,upper=2>[N]  alpha;
  vector<lower=0,upper=5>[N]  cons;
  vector<lower=0,upper=10>[N] lambda;
    
  for (i in 1:N) {
    A[i]      = Phi_approx( mu_p[1] + sigma[1] * A_pr[i] );
    alpha[i]  = Phi_approx( mu_p[2] + sigma[2] * alpha_pr[i] ) * 2;
    cons[i]   = Phi_approx( mu_p[3] + sigma[3] * cons_pr[i] ) * 5;
    lambda[i] = Phi_approx( mu_p[4] + sigma[4] * lambda_pr[i] ) * 10;
  }
}

model {
# Hyperparameters
  mu_p  ~ normal(0, 1);
  sigma ~ cauchy(0, 5);
  
  # individual parameters
  A_pr      ~ normal(0,1);
  alpha_pr  ~ normal(0,1);
  cons_pr   ~ normal(0,1);
  lambda_pr ~ normal(0,1);
    
  for (i in 1:N) {
    # Define values
    vector[4] ev;
    real curUtil;     # utility of curFb
    real theta;       # theta = 3^c - 1  

    # Initialize values
    theta = pow(3, cons[i]) -1;
    ev = initV; # initial ev values
        
    for (t in 1:Tsubj[i]) {
      # softmax choice
      choice[i, t] ~ categorical_logit( theta * ev );
      
      if ( outcome[i,t] >= 0) {  # x(t) >= 0
        curUtil = pow(outcome[i,t], alpha[i]);
      } else {                  # x(t) < 0
        curUtil = -1 * lambda[i] * pow( -1*outcome[i,t], alpha[i]);
      }
            
      # delta
      ev[ choice[i, t] ] = ev[ choice[i, t] ] + A[i]*(curUtil - ev[ choice[i, t] ]);
    }
  }
}

generated quantities {
  # For group level parameters
  real<lower=0,upper=1>  mu_A;
  real<lower=0,upper=2>  mu_alpha;
  real<lower=0,upper=5>  mu_cons;
  real<lower=0,upper=10> mu_lambda;
  
  # For log likelihood calculation
  real log_lik[N];

  mu_A      = Phi_approx(mu_p[1]);
  mu_alpha  = Phi_approx(mu_p[2]) * 2;
  mu_cons   = Phi_approx(mu_p[3]) * 5;
  mu_lambda = Phi_approx(mu_p[4]) * 10;

  { # local section, this saves time and space
    for (i in 1:N) {
      # Define values
      vector[4] ev;
      real curUtil;     # utility of curFb
      real theta;       # theta = 3^c - 1  
      
      # Initialize values
      log_lik[i] = 0;
      theta      = pow(3, cons[i]) -1;
      ev         = initV; # initial ev values
            
      for (t in 1:Tsubj[i]) {
        # softmax choice
        log_lik[i] = log_lik[i] + categorical_logit_lpmf( choice[i, t] | theta * ev );
        
        if ( outcome[i,t] >= 0) {  # x(t) >= 0
          curUtil = pow(outcome[i,t], alpha[i]);
        } else {                  # x(t) < 0
          curUtil = -1 * lambda[i] * pow( -1*outcome[i,t], alpha[i]);
        }
              
        # delta
        ev[ choice[i, t] ] = ev[ choice[i, t] ] + A[i]*(curUtil - ev[ choice[i, t] ]);
      }
    }
  }
}
