int<lower=1, upper=2> level1_choice[N,T];  // 1: left, 2: right
int<lower=1, upper=4> level2_choice[N,T];  // 1-4: 1/2: commonly associated with level1=1, 3/4: commonly associated with level1=2
int<lower=0, upper=1> reward[N,T];
real<lower=0, upper=1> trans_prob;
