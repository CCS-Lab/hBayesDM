real<lower=0> gain[N, T];
real<lower=0> loss[N, T];  // absolute loss amount
real cert[N, T];
int<lower=-1, upper=1> gamble[N, T];
