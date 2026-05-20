/*
    hBayesDM is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    hBayesDM is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with hBayesDM.  If not, see <http://www.gnu.org/licenses/>.
*/

data {
  int<lower=1> N;
  int<lower=1> T;
  array[N] int<lower=1, upper=T> Tsubj;
  array[N, T] real<lower=0> gain;
  array[N, T] real<lower=0> loss; // absolute loss amount
  array[N, T] real cert;
  array[N, T] int<lower=-1, upper=1> gamble;
}
transformed data {
  
}
parameters {
  vector[2] mu_pr;
  vector<lower=0>[2] sigma;
  vector[N] lambda_pr;
  vector[N] tau_pr;
}
transformed parameters {
  vector<lower=0, upper=5>[N] lambda;
  vector<lower=0, upper=30>[N] tau;
  
  for (i in 1 : N) {
    lambda[i] = Phi_approx(mu_pr[1] + sigma[1] * lambda_pr[i]) * 5;
    tau[i] = Phi_approx(mu_pr[2] + sigma[2] * tau_pr[i]) * 30;
  }
}
model {
  // ra_prospect: Original model in Soko-Hessner et al 2009 PNAS
  // hyper parameters
  mu_pr ~ normal(0, 1.0);
  sigma ~ normal(0, 0.2);
  
  // individual parameters w/ Matt trick
  lambda_pr ~ normal(0, 1.0);
  tau_pr ~ normal(0, 1.0);
  
  for (i in 1 : N) {
    for (t in 1 : Tsubj[i]) {
      real evSafe; // evSafe, evGamble, pGamble can be a scalar to save memory and increase speed.
      real evGamble; // they are left as arrays as an example for RL models.
      real pGamble;
      
      // loss[i, t]=absolute amount of loss (pre-converted in R)
      evSafe = cert[i, t];
      evGamble = 0.5 * (gain[i, t] - lambda[i] * loss[i, t]);
      pGamble = inv_logit(tau[i] * (evGamble - evSafe));
      gamble[i, t] ~ bernoulli(pGamble);
    }
  }
}
generated quantities {
  real<lower=0, upper=5> mu_lambda;
  real<lower=0, upper=30> mu_tau;
  
  array[N] real log_lik;
  
  // For posterior predictive check
  array[N, T] real y_pred;
  
  // Set all posterior predictions to 0 (avoids NULL values)
  for (i in 1 : N) {
    for (t in 1 : T) {
      y_pred[i, t] = -1;
    }
  }
  
  mu_lambda = Phi_approx(mu_pr[1]) * 5;
  mu_tau = Phi_approx(mu_pr[2]) * 30;
  
  {
    // local section, this saves time and space
    for (i in 1 : N) {
      log_lik[i] = 0;
      for (t in 1 : Tsubj[i]) {
        real evSafe; // evSafe, evGamble, pGamble can be a scalar to save memory and increase speed.
        real evGamble; // they are left as arrays as an example for RL models.
        real pGamble;
        
        evSafe = cert[i, t];
        evGamble = 0.5 * (gain[i, t] - lambda[i] * loss[i, t]);
        pGamble = inv_logit(tau[i] * (evGamble - evSafe));
        log_lik[i] += bernoulli_lpmf(gamble[i, t] | pGamble);
        
        // generate posterior prediction for current trial
        y_pred[i, t] = bernoulli_rng(pGamble);
      }
    }
  }
}

