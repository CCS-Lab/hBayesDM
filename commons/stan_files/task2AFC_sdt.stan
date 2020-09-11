// Hierarchical Signal Detection Theory
data {
  int<lower=1> N;
  int<lower=0> h[N];
  int<lower=0> f[N];
  int<lower=0> signal[N];
  int<lower=0> noise[N];
}

parameters {
  // Hyper(group)-parameters
  vector[2] mu_pr;
  vector<lower=0>[2] sigma;

  // Subject-level raw parameters (for Matt trick)
  vector[N] d_pr;
  vector[N] c_pr;
}

transformed parameters {

  //Transform subject-level raw parameters
  vector[N] d;
  vector[N] c;

  real<lower=0,upper=1> thetah[N];
  real<lower=0,upper=1> thetaf[N];

  for (i in 1:N){
    d[i] = mu_pr[1] + sigma[1] * d_pr[i];
    c[i] = mu_pr[2] + sigma[2] * c_pr[i];
  }

  // Reparameterization Using Equal-Variance Gaussian SDT
  for(i in 1:N) {
    thetah[i] = Phi_approx(d[i] / 2 - c[i]);
    thetaf[i] = Phi_approx(-d[i] / 2 - c[i]);
  }
}
model {
  // Hyperparameters
  mu_pr ~ normal(0, 1);
  sigma ~ normal(0, 0.2);

  // Individual parameters
  d_pr ~ normal(0, 1);
  c_pr ~ normal(0, 1);

  // Observed counts
  h ~ binomial(signal, thetah);
  f ~ binomial(noise, thetaf);
}
generated quantities{
  real mu_d;
  real mu_c;

  real log_lik[N, 2];

  // For posterior predictive check
  real y_pred[N, 2];

  //set all posterior predictions to 0 (avoids NULL values)
  for (i in 1:N){
    y_pred[i,1] = -1; // Hit
    y_pred[i,2] = -1; // False alarm
  }

  mu_d = mu_pr[1];
  mu_c = mu_pr[2];


  { // local section, this saves time and space
    for (i in 1:N){
      log_lik[i, 1] = 0;
      log_lik[i, 1] += binomial_lpmf(h[i] | signal[i], thetah[i]);
      log_lik[i, 2] = 0;
      log_lik[i, 2] += binomial_lpmf(f[i] | noise[i], thetaf[i]);

      y_pred[i,1] = binomial_rng(signal[i], thetah[i]);
      y_pred[i,2] = binomial_rng(noise[i], thetaf[i]);

    }
  }
}
