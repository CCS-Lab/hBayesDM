// DDM from Pedersen, Frank & Biele (2017) https://doi.org/10.3758/s13423-016-1199-y

functions{
  // Random number generator from Shahar et al. (2019) https://doi.org/10.1371/journal.pcbi.1006803
  vector wiener_rng(real a, real tau, real z, real d) {
    real dt;
    real sigma;
    real p;
    real y;
    real i;
    real aa;
    real ch;
    real rt;
    vector[2] ret;
    
    dt = .0001;
    sigma = 1;
    
    y = z * a;  // starting point
    p = .5 * (1 + ((d * sqrt(dt)) / sigma));
    i = 0;
    while (y < a && y > 0){
      aa = uniform_rng(0,1);
      if (aa <= p){
        y = y + sigma * sqrt(dt);
        i = i + 1;
      } else {
        y = y - sigma * sqrt(dt);
        i = i + 1;
      }
    }
    ch = (y <= 0) * 1 + 1;  // Upper boundary choice -> 1, lower boundary choice -> 2
    rt = i * dt + tau;
    
    ret[1] = ch;
    ret[2] = rt;
    return ret;
  }
}

data {
  int<lower=1> N;                         // Number of subjects
  int<lower=1> T;                         // Maximum number of trials
  int<lower=1> Tsubj[N];                  // Number of trials for each subject
  int<lower=1> n_cond;                    // Number of task conditions
  int<lower=-1, upper=n_cond> cond[N, T]; // Task condition  (NA: -1)
  int<lower=-1, upper=2> choice[N, T];    // Response (NA: -1)
  real RT[N, T];                          // Response time
  real minRT[N];                          // Minimum RT for each subject of the observed data
  real RTbound;                           // Lower bound or RT across all subjects (e.g., 0.1 second)
  real prob[n_cond];                      // Reward probability for each task condition (for posterior predictive check)
}

transformed data {
}

parameters {
  // Group-level raw parameters
  vector[5] mu_pr;
  vector<lower=0>[5] sigma;
  
  // Subject-level raw parameters (for Matt trick)
  vector[N] a_pr;         // Boundary separation
  vector[N] tau_pr;       // Non-decision time                 
  vector[N] d1_pr;        // Drift rate 1
  vector[N] d2_pr;        // Drift rate 2
  vector[N] d3_pr;        // Drift rate 3 (Assumes n_cond = 3)
}

transformed parameters {  
  // Transform subject-level raw parameters
  vector<lower=0>[N] a;                                       
  vector<lower=RTbound, upper=max(minRT)>[N] tau;               
  vector[N] d1;
  vector[N] d2;
  vector[N] d3;
  
  for (i in 1:N) {
    a[i]     = exp(mu_pr[1] + sigma[1] * a_pr[i]);
    tau[i]   = Phi_approx(mu_pr[2] + sigma[2] * tau_pr[i]) * (minRT[i] - RTbound) + RTbound; 
  }
  d1 = mu_pr[3] + sigma[3] * d1_pr;
  d2 = mu_pr[4] + sigma[4] * d2_pr;
  d3 = mu_pr[5] + sigma[5] * d3_pr;
}

model {
  // Group-level raw parameters
  mu_pr ~ normal(0, 1);
  sigma ~ normal(0, 0.2);                           
  
  // Individual parameters
  a_pr     ~ normal(0, 1);
  tau_pr   ~ normal(0, 1);
  d1_pr    ~ normal(0, 1);
  d2_pr    ~ normal(0, 1);
  d3_pr    ~ normal(0, 1);

  // Subject loop
  for (i in 1:N) {
    // Declare variables
    int r;
    int s;
    real d;
    
    // Drift rates
    vector[3] d_vec;   // Assumes n_cond = 3
    d_vec[1] = d1[i];
    d_vec[2] = d2[i];
    d_vec[3] = d3[i];         
    
    // Trial loop
    for (t in 1:Tsubj[i]) {
      // Save values to variables
      s = cond[i, t];
      r = choice[i, t];

      // Drift diffusion process
      d = d_vec[s];  // Drift rate, Q[s, 1]: upper boundary option, Q[s, 2]: lower boundary option
      if (r == 1) { 
        RT[i, t] ~ wiener(a[i], tau[i], 0.5, d); 
      } else {
        RT[i, t] ~ wiener(a[i], tau[i], 0.5, -d); 
      }
    }
  }
}

generated quantities {
  // For group level parameters
  real<lower=0> mu_a;
  real<lower=RTbound, upper=max(minRT)> mu_tau;
  real mu_d1;
  real mu_d2;
  real mu_d3;
  
  // For log likelihood
  real log_lik[N];
  
  // For posterior predictive check (one-step method)
  matrix[N, T] choice_os; 
  matrix[N, T] RT_os; 
  vector[2]    tmp_os; 
  
  // Assign group-level parameter values
  mu_a      = exp(mu_pr[1]);
  mu_tau    = Phi_approx(mu_pr[2]) * (mean(minRT) - RTbound) + RTbound;
  mu_d1      = mu_pr[3];
  mu_d2      = mu_pr[4];
  mu_d3      = mu_pr[5];
  
  // Set all posterior predictions to -1 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      choice_os[i, t] = -1;
      RT_os[i, t]     = -1;
    }
  }
  
  { // local section, this saves time and space
    // Subject loop
    for (i in 1:N) {
      // Declare variables
      int r;
      int r_sm;
      int s;
      real d;
      real d_sm;
      
      // Drift rates
      vector[3] d_vec;   // Assumes n_cond = 3
      d_vec[1] = d1[i];
      d_vec[2] = d2[i];
      d_vec[3] = d3[i];
      
      // Initialized log likelihood
      log_lik[i] = 0;
      
      // Trial loop
      for (t in 1:Tsubj[i]) {
        // Save values to variables
        s = cond[i, t];
        r = choice[i, t];
        
        //////////// Posterior predictive check (one-step method) ////////////
        
        // Calculate Drift rate
        d = d_vec[s];  // Q[s, 1]: upper boundary option, Q[s, 2]: lower boundary option
        
        // Drift diffusion process
        if (r == 1) { 
          log_lik[i] += wiener_lpdf(RT[i, t] | a[i], tau[i], 0.5, d);
        } else {
          log_lik[i] += wiener_lpdf(RT[i, t] | a[i], tau[i], 0.5, -d);
        }
        
        tmp_os          = wiener_rng(a[i], tau[i], 0.5, d);
        choice_os[i, t] = tmp_os[1];
        RT_os[i, t]     = tmp_os[2];
      }
    }
  }
}
