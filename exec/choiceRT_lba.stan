// The model published in Annis, J., Miller, B. J., & Palmeri, T. J. (2016). 
// Bayesian inference with Stan: A tutorial on adding custom distributions. Behavior research methods, 1-24.
functions{
  real lba_pdf(real t, real b, real A, real v_pdf, real s) {
    //PDF of the LBA model
    real b_A_tv_ts;
    real b_tv_ts;
    real term_1b;
    real term_2b;
    real term_3b;
    real term_4b;
    real pdf;
          
    b_A_tv_ts = (b - A - t*v_pdf)/(t*s);
    b_tv_ts   = (b - t*v_pdf)/(t*s);
    
    term_1b = v_pdf*Phi(b_A_tv_ts);
    term_2b = s*exp(normal_lpdf(fabs(b_A_tv_ts) | 0,1)); 
    term_3b = v_pdf*Phi(b_tv_ts);
    term_4b = s*exp(normal_lpdf(fabs(b_tv_ts) | 0,1)); 
    
    pdf = (1/A)*(-term_1b + term_2b + term_3b - term_4b);
          
    return pdf;
  }
     
  real lba_cdf(real t, real b, real A, real v_cdf, real s) {
    //CDF of the LBA model
    real b_A_tv;
    real b_tv;
    real ts;
    real term_1a;
    real term_2a;
    real term_3a;
    real term_4a;
    real cdf;	
          
    b_A_tv = b - A - t*v_cdf;
    b_tv   = b - t*v_cdf;
    ts     = t*s;
    
    term_1a = b_A_tv/A * Phi(b_A_tv/ts);	
    term_2a = b_tv/A   * Phi(b_tv/ts);
    term_3a = ts/A     * exp(normal_lpdf(fabs(b_A_tv/ts) | 0,1)); 
    term_4a = ts/A     * exp(normal_lpdf(fabs(b_tv/ts) | 0,1)); 
    
    cdf = 1 + term_1a - term_2a + term_3a - term_4a;
          
    return cdf;
  }
     
  real lba_lpdf(matrix RT, real d, real A, vector v, real s, real tau) {
          
    real t;
    real b;
    real cdf;
    real pdf;		
    vector[cols(RT)] prob;
    real out;
    real prob_neg;
          
    b = A + d;
    for (i in 1:cols(RT)) {	
      t = RT[1,i] - tau;
      if(t > 0) {			
        cdf = 1;
        for(j in 1:num_elements(v)) {
          if(RT[2,i] == j){
            pdf = lba_pdf(t, b, A, v[j], s);
          } else {	
            cdf = lba_cdf(t, b, A, v[j], s) * cdf;
          }
        }
        prob_neg = 1;
        for(j in 1:num_elements(v)) {
          prob_neg = Phi(-v[j]/s) * prob_neg;    
        }
        prob[i] = pdf*(1-cdf);		
        prob[i] = prob[i]/(1-prob_neg);	
        if(prob[i] < 1e-10) {
          prob[i] = 1e-10;				
        }
                    
      } else {
        prob[i] = 1e-10;			
      }		
    }
    out = sum(log(prob));
    return out;		
  }
     
  vector lba_rng(real d, real A, vector v, real s, real tau) {
          
    int get_pos_drift;	
    int no_pos_drift;
    int get_first_pos;
    vector[num_elements(v)] drift;
    int max_iter;
    int iter;
    real start[num_elements(v)];
    real ttf[num_elements(v)];
    int resp[num_elements(v)];
    real rt;
    vector[2] pred;
    real b;
          
    //try to get a positive drift rate
    get_pos_drift = 1;
    no_pos_drift  = 0;
    max_iter      = 1000;
    iter          = 0;
    while(get_pos_drift) {
      for(j in 1:num_elements(v)) {
        drift[j] = normal_rng(v[j],s);
        if(drift[j] > 0) {
          get_pos_drift = 0;
        }
      }
      iter = iter + 1;
      if(iter > max_iter) {
        get_pos_drift = 0;
        no_pos_drift  = 1;
      }	
    }
    //if both drift rates are <= 0
    //return an infinite response time
    if(no_pos_drift) {
      pred[1] = -1;
      pred[2] = -1;
    } else {
      b = A + d;
      for(i in 1:num_elements(v)) {
        //start time of each accumulator	
        start[i] = uniform_rng(0,A);
        //finish times
        ttf[i] = (b-start[i])/drift[i];
      }
      //rt is the fastest accumulator finish time	
      //if one is negative get the positive drift
      resp          = sort_indices_asc(ttf);
      ttf           = sort_asc(ttf);
      get_first_pos = 1;
      iter          = 1;
      while(get_first_pos) {
        if(ttf[iter] > 0){
          pred[1]       = ttf[iter];
          pred[2]       = resp[iter]; 
          get_first_pos = 0;
        }
        iter = iter + 1;
      }
    }
    return pred;	
  }
}

data {
  int N;
  int Max_tr;
  int N_choices;
  int N_cond;
  int N_tr_cond[N, N_cond];
  matrix[2, Max_tr] RT[N, N_cond];

}
parameters {
  // Hyperparameter means
  real<lower=0> mu_d;
  real<lower=0> mu_A;
  real<lower=0> mu_tau;
  vector<lower=0>[N_choices] mu_v[N_cond];
  
  // Hyperparameter sigmas
  real<lower=0> sigma_d;
  real<lower=0> sigma_A;
  real<lower=0> sigma_tau;
  vector<lower=0>[N_choices] sigma_v[N_cond];
  
  // Individual parameters
  real<lower=0> d[N];
  real<lower=0> A[N];
  real<lower=0> tau[N];
  vector<lower=0>[N_choices] v[N,N_cond];
}

transformed parameters {
  // s is set to 1 to make model identifiable
  real s;
  s = 1;
}

model {
  // Hyperparameter means
  mu_d   ~ normal(.5,1)T[0,];
  mu_A   ~ normal(.5,1)T[0,];
  mu_tau ~ normal(.5,.5)T[0,];
  
  // Hyperparameter sigmas
  sigma_d   ~ gamma(1,1);
  sigma_A   ~ gamma(1,1);
  sigma_tau ~ gamma(1,1);
  
  // Hyperparameter means and sigmas for multiple drift rates
  for(j in 1:N_cond) {
    for(n in 1:N_choices) {
      mu_v[j,n]    ~ normal(2,1)T[0,];
      sigma_v[j,n] ~ gamma(1,1);
    }
  }
     
  for(i in 1:N) {		
    // Declare variables
    int n_trials;
    
    // Individual parameters
    d[i]   ~ normal(mu_d, sigma_d)T[0,];
    A[i]   ~ normal(mu_A, sigma_A)T[0,];
    tau[i] ~ normal(mu_tau, sigma_tau)T[0,];
    
    for(j in 1:N_cond) {
      // Store number of trials for subject/condition pair
      n_trials = N_tr_cond[i,j];
      
      for(n in 1:N_choices){
        // Drift rate is normally distributed
        v[i,j,n] ~ normal(mu_v[j,n], sigma_v[j,n])T[0,];
      }
      // Likelihood of RT x Choice
      RT[i,j,,1:n_trials] ~ lba(d[i], A[i], v[i,j,], s, tau[i]);
    }		
  }	
}
generated quantities {
  // Declare variables
  int n_trials;
  
  // For log likelihood calculation
  real log_lik[N];
  
  // For posterior predictive check
  matrix[2, Max_tr] y_pred[N, N_cond];
  
  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N) {
    for (j in 1:N_cond) {
      for (t in 1:Max_tr) {
        y_pred[i,j,,t] = rep_vector(-1, 2);
      }
    }
  }
   
  { // local section, this saves time and space
    for(i in 1:N) {
      // Initialize variables
      log_lik[i] = 0;
      
      for(j in 1:N_cond) {
        // Store number of trials for subject/condition pair
        n_trials = N_tr_cond[i,j];
        
        // Sum likelihood over conditions within subjects
        log_lik[i] = log_lik[i] + lba_lpdf(RT[i,j,,1:n_trials] | d[i], A[i], v[i,j,], s, tau[i]);
        
        for (t in 1:n_trials) {
          // generate posterior predictions
          y_pred[i,j,,t] = lba_rng(d[i], A[i], v[i,j,], s, tau[i]);
        }
      }
    }
    // end of subject loop
  }
}
