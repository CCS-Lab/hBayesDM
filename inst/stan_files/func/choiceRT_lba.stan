/*
 * Probability density function for the linear ballistic accumulator model
 */
real lba_pdf(real t, real b, real A, real v, real s) {
  real b_A_tv_ts;
  real b_tv_ts;
  real term_1;
  real term_2;
  real term_3;
  real term_4;

  b_A_tv_ts = (b - A - t * v)/(t * s);
  b_tv_ts = (b - t * v)/(t * s);

  term_1 = v * Phi(b_A_tv_ts);
  term_2 = s * exp(normal_lpdf(b_A_tv_ts | 0, 1));
  term_3 = v * Phi(b_tv_ts);
  term_4 = s * exp(normal_lpdf(b_tv_ts | 0, 1));

  return (-term_1 + term_2 + term_3 - term_4) / A;
}

/*
 * Cumulative density function for the linear ballistic accumulator model
 */
real lba_cdf(real t, real b, real A, real v, real s) {
  real b_A_tv;
  real b_tv;
  real ts;
  real term_1;
  real term_2;
  real term_3;
  real term_4;

  b_A_tv = b - A - t * v;
  b_tv   = b - t * v;
  ts     = t * s;

  term_1 = b_A_tv / A * Phi(b_A_tv / ts);
  term_2 = b_tv / A   * Phi(b_tv / ts);
  term_3 = ts / A     * exp(normal_lpdf(b_A_tv / ts | 0, 1));
  term_4 = ts / A     * exp(normal_lpdf(b_tv / ts | 0, 1));

  return 1 + term_1 - term_2 + term_3 - term_4;
}

/*
 * Log probability density function for the linear ballistic accumulator model
 */
real lba_lpdf(matrix RT, real d, real A, vector v, real s, real tau) {
  real t;
  real b;
  real cdf;
  real pdf;
  vector[rows(RT)] prob;
  real prob_neg;

  b = A + d;
  for (i in 1:rows(RT)) {
    t = RT[1, i] - tau;

    if (t > 0) {
      cdf = 1;

      for (j in 1:num_elements(v)) {
        if (RT[2, i] == j) {
          pdf = lba_pdf(t, b, A, v[j], s);
        } else {
          cdf *= (1-lba_cdf(t, b, A, v[j], s));
        }
      }

      prob_neg = 1;
      for (j in 1:num_elements(v)) {
        prob_neg *= Phi(-v[j] / s);
      }

      prob[i] = (pdf * cdf) / (1 - prob_neg);
      if (prob[i] < 1e-10) {
        prob[i] = 1e-10;
      }
    } else {
      prob[i] = 1e-10;
    }
  }

  return sum(log(prob));
}

/*
 * Random number generator function for the linear ballistic accumulator model
 */
vector lba_rng(real d, real A, vector v, real s, real tau) {
  int get_pos_drift;
  int no_pos_drift;
  int get_first_pos;
  vector[num_elements(v)] drift;
  int max_iter;
  int iter;
  real start[num_elements(v)];
  real ttf[num_elements(v)];
  int resp[num_elements(v)];
  real rt;
  vector[2] pred;
  real b;

  //try to get a positive drift rate
  get_pos_drift = 1;
  no_pos_drift  = 0;
  max_iter      = 1000;
  iter          = 0;

  while(get_pos_drift) {
    for (j in 1:num_elements(v)) {
      drift[j] = normal_rng(v[j], s);
      if (drift[j] > 0) {
        get_pos_drift = 0;
      }
    }
    iter += 1;
    if (iter > max_iter) {
      get_pos_drift = 0;
      no_pos_drift  = 1;
    }
  }

  // If both drift rates are <= 0, return an infinite response time
  if (no_pos_drift) {
    pred[1] = -1;
    pred[2] = -1;
  } else {
    b = A + d;
    for (i in 1:num_elements(v)) {
      // Start time of each accumulator
      start[i] = uniform_rng(0, A);
      // Finish time of each accumulator
      ttf[i] = (b - start[i]) / drift[i];
    }

    // RT is the fastest accumulator finish time
    // if one is negative get the positive drift
    resp = sort_indices_asc(ttf);
    {
      real temp_ttf[num_elements(v)];
      temp_ttf = sort_asc(ttf);
      ttf = temp_ttf;
    }
    get_first_pos = 1;
    iter = 1;
    while(get_first_pos) {
      if (ttf[iter] > 0) {
        pred[1] = ttf[iter] + tau;
        pred[2] = resp[iter];
        get_first_pos = 0;
      }
      iter += 1;
    }
  }

  return pred;
}
