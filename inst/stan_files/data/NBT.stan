int<lower=1> N;                          // Number of subjects
int<lower=1> B;                          // Max number of blocks across subjects
int<lower=1> Bsubj[N];                   // Number of blocks for each subject
int<lower=0> T;                          // Max number of trials across subjects
int<lower=0, upper=T> Tsubj[N, B];       // Number of trials/block for each subject
