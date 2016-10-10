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
  vector[6] mu_p;  
  vector<lower=0>[6] sigma; 
  vector[N] xi_pr;         # noise 
  vector[N] ep_pr;         # learning rate 
  vector[N] b_pr;          # go bias 
  vector[N] pi_pr;         # pavlovian bias 
  vector[N] rhoRew_pr;     # rho reward, inv temp
  vector[N] rhoPun_pr;     # rho punishment, inv temp 
}
transformed parameters{
  vector<lower=0,upper=1>[N] xi;
  vector<lower=0,upper=1>[N] ep;
  vector[N] b; 
  vector[N] pi; 
  vector<lower=0>[N] rhoRew;
  vector<lower=0>[N] rhoPun;
     
  for (i in 1:N) {
    xi[i]  = Phi_approx( mu_p[1] + sigma[1] * xi_pr[i] );
    ep[i]  = Phi_approx( mu_p[2] + sigma[2] * ep_pr[i] );
  }
  b      = mu_p[3] + sigma[3] * b_pr; # vectorization
  pi     = mu_p[4] + sigma[4] * pi_pr;
  rhoRew = exp( mu_p[5] + sigma[5] * rhoRew_pr );
  rhoPun = exp( mu_p[6] + sigma[6] * rhoPun_pr );
}
model {  
# gng_m4: RW(rew/pun) + noise + bias + pi model (M5 in Cavanagh et al 2013 J Neuro)
  # hyper parameters
  mu_p  ~ normal(0, 1.0); 
  sigma ~ cauchy(0, 5.0);
  
  # individual parameters w/ Matt trick
  xi_pr     ~ normal(0, 1.0);   
  ep_pr     ~ normal(0, 1.0);   
  b_pr      ~ normal(0, 1.0); 
  pi_pr     ~ normal(0, 1.0); 
  rhoRew_pr ~ normal(0, 1.0);
  rhoPun_pr ~ normal(0, 1.0);

  for (i in 1:N) {
    vector[4] wv_g;  # action wegith for go
    vector[4] wv_ng; # action wegith for nogo
    vector[4] qv_g;  # Q value for go
    vector[4] qv_ng; # Q value for nogo
    vector[4] sv;    # stimulus value 
    vector[4] pGo;   # prob of go (press) 

    wv_g  = initV;
    wv_ng = initV;
    qv_g  = initV;
    qv_ng = initV;
    sv    = initV;
  
    for (t in 1:Tsubj[i])  {
      wv_g[ cue[i,t] ]  = qv_g[ cue[i,t] ] + b[i] + pi[i] * sv[ cue[i,t] ];
      wv_ng[ cue[i,t] ] = qv_ng[ cue[i,t] ];  # qv_ng is always equal to wv_ng (regardless of action)      
      pGo[ cue[i,t] ]   = inv_logit( wv_g[ cue[i,t] ] - wv_ng[ cue[i,t] ] ); 
      pGo[ cue[i,t] ]   = pGo[ cue[i,t] ] * (1 - xi[i]) + xi[i]/2;  # noise
      pressed[i,t] ~ bernoulli( pGo[ cue[i,t] ] );
      
      # after receiving feedback, update sv[t+1]
      if (outcome[i,t] >= 0) {
        sv[ cue[i,t] ] = sv[ cue[i,t] ] + ep[i] * ( rhoRew[i] * outcome[i,t] - sv[ cue[i,t] ] );
      } else {
        sv[ cue[i,t] ] = sv[ cue[i,t] ] + ep[i] * ( rhoPun[i] * outcome[i,t] - sv[ cue[i,t] ] );
      }       

      # update action values
      if (pressed[i,t]) { # update go value 
        if (outcome[i,t] >=0) {
          qv_g[ cue[i,t] ] = qv_g[ cue[i,t] ] + ep[i] * ( rhoRew[i] * outcome[i,t] - qv_g[ cue[i,t] ]);
        } else {
          qv_g[ cue[i,t] ] = qv_g[ cue[i,t] ] + ep[i] * ( rhoPun[i] * outcome[i,t] - qv_g[ cue[i,t] ]);
        }
      } else { # update no-go value  
        if (outcome[i,t] >=0) {
          qv_ng[ cue[i,t] ] = qv_ng[ cue[i,t] ] + ep[i] * ( rhoRew[i] * outcome[i,t] - qv_ng[ cue[i,t] ]);  
        } else{
          qv_ng[ cue[i,t] ] = qv_ng[ cue[i,t] ] + ep[i] * ( rhoPun[i] * outcome[i,t] - qv_ng[ cue[i,t] ]);  
        }
      }  
    } # end of t loop
  } # end of i loop
}
generated quantities {
  real<lower=0, upper=1> mu_xi;
  real<lower=0, upper=1> mu_ep;
  real mu_b; 
  real mu_pi;
  real<lower=0> mu_rhoRew;
  real<lower=0> mu_rhoPun;
  real log_lik[N];
  
  mu_xi     = Phi_approx(mu_p[1]);
  mu_ep     = Phi_approx(mu_p[2]);
  mu_b      = mu_p[3];
  mu_pi     = mu_p[4];
  mu_rhoRew = exp(mu_p[5]); 
  mu_rhoPun = exp(mu_p[6]); 
  
  { # local section, this saves time and space
    for (i in 1:N) {
      vector[4] wv_g;  # action wegith for go
      vector[4] wv_ng; # action wegith for nogo
      vector[4] qv_g;  # Q value for go
      vector[4] qv_ng; # Q value for nogo
      vector[4] sv;    # stimulus value 
      vector[4] pGo;   # prob of go (press) 
  
      wv_g  = initV;
      wv_ng = initV;
      qv_g  = initV;
      qv_ng = initV;
      sv    = initV;
    
      log_lik[i] = 0;

      for (t in 1:Tsubj[i])  {
        wv_g[ cue[i,t] ]  = qv_g[ cue[i,t] ] + b[i] + pi[i] * sv[ cue[i,t] ];
        wv_ng[ cue[i,t] ] = qv_ng[ cue[i,t] ];  # qv_ng is always equal to wv_ng (regardless of action)      
        pGo[ cue[i,t] ]   = inv_logit( wv_g[ cue[i,t] ] - wv_ng[ cue[i,t] ] ); 
        pGo[ cue[i,t] ]   = pGo[ cue[i,t] ] * (1 - xi[i]) + xi[i]/2;  # noise
        log_lik[i] = log_lik[i] + bernoulli_lpmf( pressed[i,t] | pGo[ cue[i,t] ] );
        
        # after receiving feedback, update sv[t+1]
        if (outcome[i,t] >= 0) {
          sv[ cue[i,t] ] = sv[ cue[i,t] ] + ep[i] * ( rhoRew[i] * outcome[i,t] - sv[ cue[i,t] ] );
        } else {
          sv[ cue[i,t] ] = sv[ cue[i,t] ] + ep[i] * ( rhoPun[i] * outcome[i,t] - sv[ cue[i,t] ] );
        }       
  
        # update action values
        if (pressed[i,t]) { # update go value 
          if (outcome[i,t] >=0) {
            qv_g[ cue[i,t] ] = qv_g[ cue[i,t] ] + ep[i] * ( rhoRew[i] * outcome[i,t] - qv_g[ cue[i,t] ]);
          } else {
            qv_g[ cue[i,t] ] = qv_g[ cue[i,t] ] + ep[i] * ( rhoPun[i] * outcome[i,t] - qv_g[ cue[i,t] ]);
          }
        } else { # update no-go value  
          if (outcome[i,t] >=0) {
            qv_ng[ cue[i,t] ] = qv_ng[ cue[i,t] ] + ep[i] * ( rhoRew[i] * outcome[i,t] - qv_ng[ cue[i,t] ]);  
          } else{
            qv_ng[ cue[i,t] ] = qv_ng[ cue[i,t] ] + ep[i] * ( rhoPun[i] * outcome[i,t] - qv_ng[ cue[i,t] ]);  
          }
        }  
      } # end of t loop
    } # end of i loop
  } # end of local section
}
