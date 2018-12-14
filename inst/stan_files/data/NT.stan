int<lower=1> N;                  // Number of subjects
int<lower=1> T;                  // Max number of trials across subjects
int<lower=1, upper=T> Tsubj[N];  // Number of trials/block for each subject
