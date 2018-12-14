/**
 * Subjective value function with the exponential equation form
 */
real sv_exp(real alpha, real beta, real p, real a, real v) {
  return pow(p, 1 + beta * a) * pow(v, alpha);
}

/**
 * Subjective value function with the linear equation form
 */
real sv_linear(real alpha, real beta, real p, real a, real v) {
  return (p - beta * a / 2) * pow(v, alpha);
}
