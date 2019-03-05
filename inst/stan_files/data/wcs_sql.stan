int<lower=1> N;                                       // number of subjects
int<lower=1> T;                                       // max trial
int<lower=40, upper=T> Tsubj[N];                      // number of max trials per subject

// subject's deck choice within a trial (1, 2, 3 and 4)
int<lower=0, upper=4> choice[N, T];

// whether subject's choice is correct or not within a trial (1 and 0)
int<lower=-1, upper=1> outcome[N, T];

// Which dimension(color, form, number) each of the 4 decks matches to within a trial
matrix<lower=0, upper=1>[3, 4] match[T];
