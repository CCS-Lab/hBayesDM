# _reg: generates model-based regressors
data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  real outcome[N, T];
  int<lower=0, upper=1> pressed[N, T];
  int<lower=1, upper=4> cue[N, T];
}
transformed data {
  vector[4] initV;
  initV  = rep_vector(0.0, 4);
}
parameters {
  # declare as vectors for vectorizing
  vector[4] mu_p;  
  vector<lower=0>[4] sigma; 
  vector[N] xi_pr;         # noise 
  vector[N] ep_pr;         # learning rate 
  vector[N] b_pr;          # go bias 
  vector[N] rho_pr;        # rho, inv temp 
}
transformed parameters{
  vector<lower=0,upper=1>[N] xi;
  vector<lower=0,upper=1>[N] ep;
  vector[N] b; 
  vector<lower=0>[N] rho;
     
  for (i in 1:N) {
    xi[i]  = Phi_approx( mu_p[1] + sigma[1] * xi_pr[i] );
    ep[i]  = Phi_approx( mu_p[2] + sigma[2] * ep_pr[i] );
  }
  b   = mu_p[3] + sigma[3] * b_pr; # vectorization
  rho = exp( mu_p[4] + sigma[4] * rho_pr );
}
model {  
# gng_m2: RW + noise + bias model in Guitart-Masip et al 2012
  # hyper parameters
  mu_p[1]  ~ normal(0, 1.0); 
  mu_p[2]  ~ normal(0, 1.0); 
  mu_p[3]  ~ normal(0, 10.0); 
  mu_p[4]  ~ normal(0, 1.0); 
  sigma ~ cauchy(0, 5.0);
  
  # individual parameters w/ Matt trick
  xi_pr  ~ normal(0, 1.0);   
  ep_pr  ~ normal(0, 1.0);   
  b_pr   ~ normal(0, 1.0);   
  rho_pr ~ normal(0, 1.0);

  for (i in 1:N) {
    vector[4] wv_g;  # action wegith for go
    vector[4] wv_ng; # action wegith for nogo
    vector[4] qv_g;  # Q value for go
    vector[4] qv_ng; # Q value for nogo
    vector[4] pGo;   # prob of go (press) 

    wv_g  = initV;
    wv_ng = initV;
    qv_g  = initV;
    qv_ng = initV;
  
    for (t in 1:Tsubj[i])  {
      wv_g[ cue[i,t] ]  = qv_g[ cue[i,t] ] + b[i];
      wv_ng[ cue[i,t] ] = qv_ng[ cue[i,t] ];  # qv_ng is always equal to wv_ng (regardless of action)      
      pGo[ cue[i,t] ]   = inv_logit( wv_g[ cue[i,t] ] - wv_ng[ cue[i,t] ] ); 
      pGo[ cue[i,t] ]   = pGo[ cue[i,t] ] * (1 - xi[i]) + xi[i]/2;  # noise
      pressed[i,t] ~ bernoulli( pGo[ cue[i,t] ] );
      
      # update action values
      if (pressed[i,t]) { # update go value 
        qv_g[ cue[i,t] ]  = qv_g[ cue[i,t] ] + ep[i] * (rho[i] * outcome[i,t] - qv_g[ cue[i,t] ]);
      } else { # update no-go value  
        qv_ng[ cue[i,t] ] = qv_ng[ cue[i,t] ] + ep[i] * (rho[i] * outcome[i,t] - qv_ng[ cue[i,t] ]);  
      }  
    } # end of t loop
  } # end of i loop
}
generated quantities {
  real<lower=0, upper=1> mu_xi;
  real<lower=0, upper=1> mu_ep;
  real mu_b; 
  real<lower=0> mu_rho;
  real log_lik[N];
  real Qgo[N, T];
  real Qnogo[N, T];
  real Wgo[N, T];
  real Wnogo[N, T];
  
  mu_xi  = Phi_approx(mu_p[1]);
  mu_ep  = Phi_approx(mu_p[2]);
  mu_b   = mu_p[3];
  mu_rho = exp(mu_p[4]); 
  
  { # local section, this saves time and space
    for (i in 1:N) {
      vector[4] wv_g;  # action wegith for go
      vector[4] wv_ng; # action wegith for nogo
      vector[4] qv_g;  # Q value for go
      vector[4] qv_ng; # Q value for nogo
      vector[4] pGo;   # prob of go (press) 
  
      wv_g  = initV;
      wv_ng = initV;
      qv_g  = initV;
      qv_ng = initV;
    
      log_lik[i] = 0;

      for (t in 1:Tsubj[i])  {
        wv_g[ cue[i,t] ]  = qv_g[ cue[i,t] ] + b[i];
        wv_ng[ cue[i,t] ] = qv_ng[ cue[i,t] ];  # qv_ng is always equal to wv_ng (regardless of action)      
        pGo[ cue[i,t] ]   = inv_logit( wv_g[ cue[i,t] ] - wv_ng[ cue[i,t] ] ); 
        pGo[ cue[i,t] ]   = pGo[ cue[i,t] ] * (1 - xi[i]) + xi[i]/2;  # noise
        log_lik[i] = log_lik[i] + bernoulli_lpmf( pressed[i,t] | pGo[ cue[i,t] ] );
        
        # Model regressors --> store values before being updated
        Qgo[i,t]   = qv_g[ cue[i,t] ];
        Qnogo[i,t] = qv_ng[ cue[i,t] ];
        Wgo[i,t]   = wv_g[ cue[i,t] ];
        Wnogo[i,t] = wv_ng[ cue[i,t] ];
        
        # update action values
        if (pressed[i,t]) { # update go value 
          qv_g[ cue[i,t] ]  = qv_g[ cue[i,t] ] + ep[i] * (rho[i] * outcome[i,t] - qv_g[ cue[i,t] ]);
        } else { # update no-go value  
          qv_ng[ cue[i,t] ] = qv_ng[ cue[i,t] ] + ep[i] * (rho[i] * outcome[i,t] - qv_ng[ cue[i,t] ]);  
        }  
      } # end of t loop
    } # end of i loop
  } # end of local section
}
