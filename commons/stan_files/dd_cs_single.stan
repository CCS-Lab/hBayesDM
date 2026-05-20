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
  int<lower=1> Tsubj;
  array[Tsubj] real<lower=0> delay_later;
  array[Tsubj] real<lower=0> amount_later;
  array[Tsubj] real<lower=0> delay_sooner;
  array[Tsubj] real<lower=0> amount_sooner;
  array[Tsubj] int<lower=-1, upper=1> choice; // 0 for instant reward, 1 for delayed reward
}
transformed data {
  
}
parameters {
  real<lower=0, upper=1> r; // (exponential) discounting rate
  real<lower=0, upper=10> s; // impatience
  real<lower=0, upper=5> beta; // inverse temperature
}
transformed parameters {
  array[Tsubj] real ev_later;
  array[Tsubj] real ev_sooner;
  
  for (t in 1 : Tsubj) {
    ev_later[t] = amount_later[t] * exp(-1 * pow(r * delay_later[t], s));
    ev_sooner[t] = amount_sooner[t] * exp(-1 * pow(r * delay_sooner[t], s));
  }
}
model {
  // constant-sensitivity model (Ebert & Prelec, 2007)
  // hyperparameters
  r ~ uniform(0, 1);
  s ~ uniform(0, 10);
  beta ~ uniform(0, 5);
  
  for (t in 1 : Tsubj) {
    choice[t] ~ bernoulli_logit(beta * (ev_later[t] - ev_sooner[t]));
  }
}
generated quantities {
  real logR;
  real log_lik;
  
  // For posterior predictive check
  array[Tsubj] real y_pred;
  
  logR = log(r);
  
  {
    // local section, this saves time and space
    log_lik = 0;
    
    for (t in 1 : Tsubj) {
      log_lik += bernoulli_logit_lpmf(choice[t] | beta
                                                  * (ev_later[t]
                                                     - ev_sooner[t]));
      
      // generate posterior prediction for current trial
      y_pred[t] = bernoulli_rng(inv_logit(beta * (ev_later[t] - ev_sooner[t])));
    }
  }
}

