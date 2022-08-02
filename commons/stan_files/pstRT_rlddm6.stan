// Model 6 from Pedersen, Frank & Biele (2017) https://doi.org/10.3758/s13423-016-1199-y

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
  int<lower=-1> Isubj[N, T];              // Trial number for each task condition
  int<lower=1> n_cond;                    // Number of task conditions
  int<lower=-1, upper=n_cond> cond[N, T]; // Task condition  (NA: -1)
  int<lower=-1, upper=2> choice[N, T];    // Response (NA: -1)
  real RT[N, T];                          // Response time
  real fd[N, T];                          // Feedback
  real initQ;                             // Initial Q value
  real minRT[N];                          // Minimum RT for each subject of the observed data
  real RTbound;                           // Lower bound or RT across all subjects (e.g., 0.1 second)
  real prob[n_cond];                      // Reward probability for each task condition (for posterior predictive check)
}

transformed data {
}

parameters {
  // Group-level raw parameters
  vector[6] mu_pr;
  vector<lower=0>[6] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] a_pr;             // Boundary separation
  vector[N] bp_pr;            // Boundary separation power
  vector[N] tau_pr;           // Non-decision time
  vector[N] v_pr;             // Drift rate scaling
  vector[N] alpha_pos_pr;     // Learning rate for positive prediction error
  vector[N] alpha_neg_pr;     // Learning rate for negative prediction error
}

transformed parameters {
  // Transform subject-level raw parameters
  vector<lower=0>[N] a;
  vector<lower=-0.3, upper=0.3>[N] bp;
  vector<lower=RTbound, upper=max(minRT)>[N] tau;
  vector[N] v;
  vector<lower=0, upper=1>[N] alpha_pos;
  vector<lower=0, upper=1>[N] alpha_neg;

  for (i in 1:N) {
    a[i]         = exp(mu_pr[1] + sigma[1] * a_pr[i]);
    bp[i]        = Phi_approx(mu_pr[2] + sigma[2] * bp_pr[i]) * 0.6 - 0.3;
    tau[i]       = Phi_approx(mu_pr[3] + sigma[3] * tau_pr[i]) * (minRT[i] - RTbound) + RTbound;
    alpha_pos[i] = Phi_approx(mu_pr[5] + sigma[5] * alpha_pos_pr[i]);
    alpha_neg[i] = Phi_approx(mu_pr[6] + sigma[6] * alpha_neg_pr[i]);
  }
  v  = mu_pr[4] + sigma[4] * v_pr;
}

model {
  // Group-level raw parameters
  mu_pr ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // Individual parameters
  a_pr         ~ normal(0, 1);
  bp_pr        ~ normal(0, 1);
  tau_pr       ~ normal(0, 1);
  v_pr         ~ normal(0, 1);
  alpha_pos_pr ~ normal(0, 1);
  alpha_neg_pr ~ normal(0, 1);

  // Subject loop
  for (i in 1:N) {
    // Declare variables
    int r;
    int s;
    real d;
    real PE;

    // Initialize Q-values
    matrix[n_cond, 2] Q;
    Q = rep_matrix(initQ, n_cond, 2);

    // Trial loop
    for (t in 1:Tsubj[i]) {
      // Save values to variables
      s = cond[i, t];
      r = choice[i, t];

      // Drift diffusion process
      d = (Q[s, 1] - Q[s, 2]) * v[i];  // Drift rate, Q[s, 1]: upper boundary option, Q[s, 2]: lower boundary option
      if (r == 1) {
        RT[i, t] ~ wiener(a[i]*(Isubj[i, t]/10.0)^bp[i], tau[i], 0.5, d);
      } else {
        RT[i, t] ~ wiener(a[i]*(Isubj[i, t]/10.0)^bp[i], tau[i], 0.5, -d);
      }
      //
      // Update Q-value based on the valence of PE
      PE = fd[i, t] - Q[s, r];

      if (PE > 0) {
        Q[s, r] += alpha_pos[i] * PE;
      }
      else {
        Q[s, r] += alpha_neg[i] * PE;
      }
    }
  }
}

generated quantities {
  // For group level parameters
  real<lower=0> mu_a;
  real<lower=-0.3, upper=0.3> mu_bp;
  real<lower=RTbound, upper=max(minRT)> mu_tau;
  real mu_v;
  real<lower=0, upper=1> mu_alpha_pos;
  real<lower=0, upper=1> mu_alpha_neg;

  // For log likelihood
  real log_lik[N];

  // For model regressors
  matrix[N, T] Q1;
  matrix[N, T] Q2;

  // For posterior predictive check (one-step method)
  matrix[N, T] choice_os;
  matrix[N, T] RT_os;
  vector[2]    tmp_os;

  // For posterior predictive check (simulation method)
  matrix[N, T] choice_sm;
  matrix[N, T] RT_sm;
  matrix[N, T] fd_sm;
  vector[2]    tmp_sm;
  real         rand;

  // Assign group-level parameter values
  mu_a          = exp(mu_pr[1]);
  mu_bp         = Phi_approx(mu_pr[2]) * 0.6 - 0.3;
  mu_tau        = Phi_approx(mu_pr[3]) * (mean(minRT) - RTbound) + RTbound;
  mu_v          = mu_pr[4];
  mu_alpha_pos  = Phi_approx(mu_pr[5]);
  mu_alpha_neg  = Phi_approx(mu_pr[6]);

  // Set all posterior predictions to -1 (avoids NULL values)
  for (i in 1:N) {
    for (t in 1:T) {
      Q1[i, t]        = -1;
      Q2[i, t]        = -1;
      choice_os[i, t] = -1;
      RT_os[i, t]     = -1;
      choice_sm[i, t] = -1;
      RT_sm[i, t]     = -1;
      fd_sm[i, t]     = -1;
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
      real PE;
      real PE_sm;

      // Initialize Q-values
      matrix[n_cond, 2] Q;
      matrix[n_cond, 2] Q_sm;
      Q    = rep_matrix(initQ, n_cond, 2);
      Q_sm = rep_matrix(initQ, n_cond, 2);

      // Initialized log likelihood
      log_lik[i] = 0;

      // Trial loop
      for (t in 1:Tsubj[i]) {
        // Save values to variables
        s = cond[i, t];
        r = choice[i, t];

        //////////// Posterior predictive check (one-step method) ////////////

        // Calculate Drift rate
        d = (Q[s, 1] - Q[s, 2]) * v[i];  // Q[s, 1]: upper boundary option, Q[s, 2]: lower boundary option

        // Drift diffusion process
        if (r == 1) {
          log_lik[i] += wiener_lpdf(RT[i, t] | a[i]*(Isubj[i, t]/10.0)^bp[i], tau[i], 0.5, d);
        } else {
          log_lik[i] += wiener_lpdf(RT[i, t] | a[i]*(Isubj[i, t]/10.0)^bp[i], tau[i], 0.5, -d);
        }

        tmp_os          = wiener_rng(a[i], tau[i], 0.5, d);
        choice_os[i, t] = tmp_os[1];
        RT_os[i, t]     = tmp_os[2];

        // Model regressors --> store values before being updated
        Q1[i, t] = Q[s, 1];
        Q2[i, t] = Q[s, 2];

        // Update Q-value
        PE = fd[i, t] - Q[s, r];

        if (PE > 0) {
          Q[s, r] += alpha_pos[i] * PE;
        } else {
          Q[s, r] += alpha_neg[i] * PE;
        }

        //////////// Posterior predictive check (simulation method) ////////////

        // Calculate Drift rate
        d_sm = (Q_sm[s, 1] - Q_sm[s, 2]) * v[i];  // Q[s, 1]: upper boundary option, Q[s, 2]: lower boundary option

        // Drift diffusion process
        tmp_sm          = wiener_rng(a[i]*(Isubj[i, t]/10.0)^bp[i], tau[i], 0.5, d_sm);
        choice_sm[i, t] = tmp_sm[1];
        RT_sm[i, t]     = tmp_sm[2];

        // Determine feedback
        rand = uniform_rng(0, 1);
        if (choice_sm[i, t] == 1) {
          fd_sm[i, t] = rand <= prob[s];  // Upper boundary choice (correct)
        } else {
          fd_sm[i, t] = rand > prob[s];   // Lower boundary choice (incorrect)
        }

        // Update Q-value
        r_sm = (choice_sm[i, t] == 2) + 1;  // 'real' to 'int' conversion. 1 -> 1, 2 -> 2
        PE_sm = fd_sm[i, t] - Q_sm[s, r_sm];

        if (PE_sm > 0) {
         Q_sm[s, r_sm] += alpha_pos[i] * PE_sm;
        }
        else {
         Q_sm[s, r_sm] += alpha_neg[i] * PE_sm;
        }
      }
    }
  }
}
