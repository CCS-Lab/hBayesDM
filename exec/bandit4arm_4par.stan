# Seymour et al 2012 J neuro model, w/o C (chioce perseveration)
data {
  int<lower=1> N;
  int<lower=1> T;
  int<lower=1, upper=T> Tsubj[N];
  real rew[N, T];
  real los[N, T];
  int ydata[N, T];
}
transformed data {
  vector[4] initV;
  initV = rep_vector(0.0, 4);
}
parameters {
  # Declare all parameters as vectors for vectorizing
  # Hyper(group)-parameters  
  vector[4] mu_p;  
  vector<lower=0>[4] sigma;
    
  # Subject-level raw parameters (for Matt trick)
  vector[N] Arew_pr;
  vector[N] Apun_pr;
  vector[N] R_pr;
  vector[N] P_pr;
}
transformed parameters {
  # Transform subject-level raw parameters
  vector<lower=0, upper=1>[N] Arew;
  vector<lower=0, upper=1>[N] Apun;
  vector<lower=0, upper=100>[N] R;
  vector<lower=0, upper=100>[N] P;

  for (i in 1:N) {
    Arew[i] = Phi_approx( mu_p[1] + sigma[1] * Arew_pr[i] );
    Apun[i] = Phi_approx( mu_p[2] + sigma[2] * Apun_pr[i] );
    R[i]    = exp( mu_p[3] + sigma[3] * R_pr[i] );
    P[i]    = exp( mu_p[4] + sigma[4] * P_pr[i] );
  }
}
model {
  # Hyperparameters
  mu_p  ~ normal(0, 1);
  sigma ~ cauchy(0, 5);
  
  # individual parameters
  Arew_pr  ~ normal(0, 1.0);
  Apun_pr  ~ normal(0, 1.0);
  R_pr     ~ normal(0, 1.0);
  P_pr     ~ normal(0, 1.0);

  for (i in 1:N) {
    # Define values
    vector[4] Qr;
    vector[4] Qp;
    vector[4] PEr_fic; # prediction error - for reward fictive updating (for unchosen options)
    vector[4] PEp_fic; # prediction error - for punishment fictive updating (for unchosen options)
    vector[4] Qsum;    # Qsum = Qrew + Qpun + perseverance 

    real Qr_chosen;
    real Qp_chosen;
    real PEr; # prediction error - for reward of the chosen option
    real PEp; # prediction error - for punishment of the chosen option
    
    # Initialize values
    Qr    = initV;
    Qp    = initV;

    for (t in 1:(Tsubj[i]-1)) {
      # Prediction error signals
      PEr     = R[i]*rew[i,t] - Qr[ ydata[i,t]];
      PEp     = P[i]*los[i,t] - Qp[ ydata[i,t]];
      PEr_fic = -Qr;
      PEp_fic = -Qp;

      # store chosen deck Q values (rew and pun)
      Qr_chosen = Qr[ ydata[i,t]];
      Qp_chosen = Qp[ ydata[i,t]];
      
      # First, update Qr & Qp for all decks w/ fictive updating   
      Qr = Qr + Arew[i] * PEr_fic;
      Qp = Qp + Apun[i] * PEp_fic;
      # Replace Q values of chosen deck with correct values using stored values
      Qr[ ydata[i,t]] = Qr_chosen + Arew[i] * PEr;
      Qp[ ydata[i,t]] = Qp_chosen + Apun[i] * PEp;
      
      # Q(sum)
      Qsum = Qr + Qp; 
      
      # softmax choice
      ydata[i, t+1] ~ categorical_logit( Qsum );
      
    }
  }
}

generated quantities {
  # For group level parameters
  real<lower=0,upper=1> mu_Arew;
  real<lower=0,upper=1> mu_Apun;
  real<lower=0,upper=100> mu_R;
  real<lower=0,upper=100> mu_P;
  
  # For log likelihood calculation
  real log_lik[N];

  mu_Arew = Phi_approx(mu_p[1]);
  mu_Apun = Phi_approx(mu_p[2]);
  mu_R    = exp(mu_p[3]);
  mu_P    = exp(mu_p[4]);
  
  { # local section, this saves time and space
    for (i in 1:N) {
      # Define values
      vector[4] Qr;
      vector[4] Qp;
      vector[4] PEr_fic; # prediction error - for reward fictive updating (for unchosen options)
      vector[4] PEp_fic; # prediction error - for punishment fictive updating (for unchosen options)
      vector[4] Qsum;    # Qsum = Qrew + Qpun + perseverance 
  
      real Qr_chosen;
      real Qp_chosen;
      real PEr; # prediction error - for reward of the chosen option
      real PEp; # prediction error - for punishment of the chosen option
      
      # Initialize values
      Qr   = initV;
      Qp   = initV;
      log_lik[i] = 0.0;
  
      for (t in 1:(Tsubj[i]-1)) {
        # Prediction error signals
        PEr     = R[i]*rew[i,t] - Qr[ ydata[i,t]];
        PEp     = P[i]*los[i,t] - Qp[ ydata[i,t]];
        PEr_fic = -Qr;
        PEp_fic = -Qp;
  
        # store chosen deck Q values (rew and pun)
        Qr_chosen = Qr[ ydata[i,t]];
        Qp_chosen = Qp[ ydata[i,t]];
        
        # First, update Qr & Qp for all decks w/ fictive updating   
        Qr = Qr + Arew[i] * PEr_fic;
        Qp = Qp + Apun[i] * PEp_fic;
        # Replace Q values of chosen deck with correct values using stored values
        Qr[ ydata[i,t]] = Qr_chosen + Arew[i] * PEr;
        Qp[ ydata[i,t]] = Qp_chosen + Apun[i] * PEp;

        # Q(sum)
        Qsum = Qr + Qp; 

        # softmax choice
        log_lik[i] = log_lik[i] + categorical_logit_lpmf( ydata[i, t+1] | Qsum );
      }
    }
  }  
}
