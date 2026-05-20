# Plotting functions for each model

plot_gng_m1 <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_xi, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(xi, " (Noise)")))
  h2 = plot_dist(sample = pars$mu_ep, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plot_dist(sample = pars$mu_rho, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(rho, " (Effective size)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_gng_m2 <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_xi, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(xi, " (Noise)")))
  h2 = plot_dist(sample = pars$mu_ep, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plot_dist(sample = pars$mu_b, font_size = font_size, bin_size = bin_size, x_lab = "b (Go bias)")
  h4 = plot_dist(sample = pars$mu_rho, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(rho, " (Effective size)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_gng_m3 <- function(obj, font_size = 10, ncols = 5, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_xi, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(xi, " (Noise)")))
  h2 = plot_dist(sample = pars$mu_ep, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plot_dist(sample = pars$mu_b, font_size = font_size, bin_size = bin_size, x_lab = "b (Go bias)")
  h4 = plot_dist(sample = pars$mu_pi, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(pi, " (Pavlovian bias)")))
  h5 = plot_dist(sample = pars$mu_rho, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(rho, " (Effective size)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_gng_m4 <- function(obj, font_size = 10, ncols = 6, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_xi, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(xi, " (Noise)")))
  h2 = plot_dist(sample = pars$mu_ep, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plot_dist(sample = pars$mu_b, font_size = font_size, bin_size = bin_size, x_lab = "b (Go bias)")
  h4 = plot_dist(sample = pars$mu_pi, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(pi, " (Pavlovian bias)")))
  h5 = plot_dist(sample = pars$mu_rhoRew, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(rho[Rew], " (Rew. Sens.)")))
  h6 = plot_dist(sample = pars$mu_rhoPun, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(rho[Pun], " (Pun. Sens.)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, cols = ncols)
  return(h_all)
}

plot_igt_pvl_decay <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_A, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = "A (Decay Rate)")
  h2 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lim = c(0, 2), x_lab = expression(paste(alpha, " (Feedback Sens.)")))
  h3 = plot_dist(sample = pars$mu_cons, font_size = font_size, bin_size = bin_size, x_lim = c(0,5), x_lab = "c (Choice Consistency)")
  h4 = plot_dist(sample = pars$mu_lambda, font_size = font_size, bin_size = bin_size, x_lim = c(0,10), x_lab = expression(paste(lambda, " (Loss Aversion)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_igt_pvl_delta <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_A, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = "A (Learning Rate)")
  h2 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lim = c(0, 2), x_lab = expression(paste(alpha, " (Feedback Sens.)")))
  h3 = plot_dist(sample = pars$mu_cons, font_size = font_size, bin_size = bin_size, x_lim = c(0,5), x_lab = "c (Choice Consistency)")
  h4 = plot_dist(sample = pars$mu_lambda, font_size = font_size, bin_size = bin_size, x_lim = c(0,10), x_lab = expression(paste(lambda, " (Loss Aversion)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_igt_vpp <- function(obj, font_size = 10, ncols = 8, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_A, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = "A (Learning Rate)")
  h2 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lim = c(0, 2), x_lab = expression(paste(alpha, " (Feedback Sens.)")))
  h3 = plot_dist(sample = pars$mu_cons, font_size = font_size, bin_size = bin_size, x_lim = c(0,5), x_lab = "c (Choice Consistency)")
  h4 = plot_dist(sample = pars$mu_lambda, font_size = font_size, bin_size = bin_size, x_lim = c(0,10), x_lab = expression(paste(lambda, " (Loss Aversion)")))
  h5 = plot_dist(sample = pars$mu_epP, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(epsilon[P], " (Gain Impact)")))
  h6 = plot_dist(sample = pars$mu_epN, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(epsilon[N], " (Loss Impact)")))
  h7 = plot_dist(sample = pars$mu_K, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(kappa, " (Decay Rate)")))
  h8 = plot_dist(sample = pars$mu_w, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(omega, " (RL Weight)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, h7, h8, cols = ncols)
  return(h_all)
}

plot_igt_orl <- function(obj, font_size = 10, ncols = 5, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_Arew, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A[Rew], " (Rew. Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_Apun, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A[Pun], " (Pun. Learning Rate)")))
  h3 = plot_dist(sample = pars$mu_K, font_size = font_size, bin_size = bin_size, x_lim = c(0,5), x_lab = expression(paste(K, " (Perseverance Decay)")))
  h4 = plot_dist(sample = pars$mu_betaF, font_size = font_size, bin_size = bin_size, x_lim = c(-10,10), x_lab = expression(paste(beta[F], " (Outcome Frequency Weight)")))
  h5 = plot_dist(sample = pars$mu_betaP, font_size = font_size, bin_size = bin_size, x_lim = c(-10,10), x_lab = expression(paste(beta[P], " (Perseverance Weight)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_ra_noLA <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_rho, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(rho, " (Risk Aversion)")))
  h2 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_ra_noRA <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_lambda, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(lambda, " (Loss Aversion)")))
  h2 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_ra_prospect <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_rho, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(rho, " (Risk Aversion)")))
  h2 = plot_dist(sample = pars$mu_lambda, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(lambda, " (Loss Aversion)")))
  h3 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_bandit2arm_delta <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_A, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = "A (Learning Rate)")
  h2 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_bandit4arm_4par <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_Arew, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A[rew], " (Rew. Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_Apun, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A[pun], " (Pun. Learning Rate)")))
  h3 = plot_dist(sample = pars$mu_R, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(R, " (Rew. Sens.)")))
  h4 = plot_dist(sample = pars$mu_P, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(P, " (Pun. Sens.)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_bandit4arm_lapse <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_Arew, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A[rew], " (Rew. Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_Apun, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A[pun], " (Pun. Learning Rate)")))
  h3 = plot_dist(sample = pars$mu_R, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(R, " (Rew. Sens.)")))
  h4 = plot_dist(sample = pars$mu_P, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(P, " (Pun. Sens.)")))
  h5 = plot_dist(sample = pars$mu_xi, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(xi, " (Noise)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_prl_ewa <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_phi, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(phi, " (1 - Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_rho, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(rho, " (Experience Decay Factor)")))
  h3 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_prl_fictitious <- plot_prl_fictitious_multipleB <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_eta, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(eta, " (Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha, " (Indecision Point)")))
  h3 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_prl_fictitious_rp <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_eta_pos, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(eta[p], " (+Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_eta_neg, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(eta[n], " (-Learning Rate)")))
  h3 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha, " (Indecision Point)")))
  h4 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_prl_fictitious_rp_woa <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_eta_pos, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(eta[p], " (+Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_eta_neg, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(eta[n], " (-Learning Rate)")))
  h3 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_prl_fictitious_woa <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_eta, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(eta, " (Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_prl_rp <- plot_prl_rp_multipleB <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_Apun, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(A[pun], " (Pun. Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_Arew, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(A[rew], " (Rew. Learning Rate)")))
  h3 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_dd_hyperbolic <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_k, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(kappa, " (Discounting Rate)")))
  h2 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_dd_hyperbolic_single <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$k, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(kappa, " (Discounting Rate)")))
  h2 = plot_dist(sample = pars$logK, font_size = font_size, bin_size = bin_size, x_lab = expression(paste("log(", kappa, ")")))
  h3 = plot_dist(sample = pars$beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_dd_exp <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_r, font_size = font_size, bin_size = bin_size, x_lab = "r (Exp. Discounting Rate)")
  h2 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_dd_cs <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_r, font_size = font_size, bin_size = bin_size, x_lab = "r (Exp. Discounting Rate)")
  h2 = plot_dist(sample = pars$mu_s, font_size = font_size, bin_size = bin_size, x_lab = "s (Impatience)")
  h3 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_dd_cs_single <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$r, font_size = font_size, bin_size = bin_size, x_lab = "r (Exp. Discounting Rate)")
  h2 = plot_dist(sample = pars$logR, font_size = font_size, bin_size = bin_size, x_lab = "log(r)")
  h3 = plot_dist(sample = pars$s, font_size = font_size, bin_size = bin_size, x_lab = "s (Impatience)")
  h4 = plot_dist(sample = pars$beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_ug_bayes <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha, " (Envy)")))
  h2 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Guilt)")))
  h3 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_ug_delta <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha, " (Envy)")))
  h2 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Inverse Temp.)")))
  h3 = plot_dist(sample = pars$mu_ep, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(epsilon, " (Norm Adapt. Rate)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_choiceRT_ddm_single <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$alpha, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha, " (Boundary)")))
  h2 = plot_dist(sample = pars$beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Bias)")))
  h3 = plot_dist(sample = pars$delta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(delta, " (Drift rate)")))
  h4 = plot_dist(sample = pars$tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Non-DM time)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_choiceRT_ddm <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha, " (Boundary)")))
  h2 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Bias)")))
  h3 = plot_dist(sample = pars$mu_delta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(delta, " (Drift rate)")))
  h4 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Non-DM time)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_choiceRT_lba_single <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$d, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(d, " (Boundary)")))
  h2 = plot_dist(sample = pars$A, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(A, " (Start Point)")))
  h3 = list()
  for (cd in 1:dim(pars$v)[2]) {
    for (ch in 1:dim(pars$v)[3]) {
      h3[[paste0(cd,"-",ch)]] = plot_dist(sample = pars$v[,cd,ch], font_size = font_size, bin_size = bin_size, x_lab = bquote(v[.(cd)-.(ch)] ~ Drift ~ Rate))
    }
  }
  my_plots = list(h1,h2)
  for (i in 1:length(h3)) my_plots[[length(my_plots) + 1]] = h3[[i]]
  my_plots[[length(my_plots) + 1]] = plot_dist(sample = pars$tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Non-DM time)")))
  h_all = multiplot(plots = my_plots, cols = ncols)
  cat("Drift rates (v) are numbered as follows: v[condition-choice]. For example, v[1-2] refers to the drift rate estimate for when choice == 2 and condition == 1.")
  return(h_all)
}

plot_choiceRT_lba <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_d, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(d, " (Boundary)")))
  h2 = plot_dist(sample = pars$mu_A, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(A, " (Start Point)")))
  h3 = list()
  for (cd in 1:dim(pars$mu_v)[2]) {
    for (ch in 1:dim(pars$mu_v)[3]) {
      h3[[paste0(cd,"-",ch)]] = plot_dist(sample = pars$mu_v[,cd,ch], font_size = font_size, bin_size = bin_size, x_lab = bquote(v[.(cd)-.(ch)] ~ Drift ~ Rate))
    }
  }
  my_plots = list(h1,h2)
  for (i in 1:length(h3)) my_plots[[length(my_plots) + 1]] = h3[[i]]
  my_plots[[length(my_plots) + 1]] = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Non-DM time)")))
  h_all = multiplot(plots = my_plots, cols = ncols)
  cat("Drift rates (v) are numbered as follows: v[condition-choice]. For example, v[1-2] refers to the drift rate estimate for when choice == 2 and condition == 1.")
  return(h_all)
}

plot_peer_ocu <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_rho, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(rho, " (Risk Pref.)")))
  h2 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Inverse Temp.)")))
  h3 = plot_dist(sample = pars$mu_ocu, font_size = font_size, bin_size = bin_size, x_lab = "OCU")
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_ts_par7 <- function(obj, font_size = 10, ncols = 7, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_a1, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(alpha, " (Lev 1)")))
  h2 = plot_dist(sample = pars$mu_beta1, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Lev 1)")))
  h3 = plot_dist(sample = pars$mu_a2, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(alpha, " (Lev 2)")))
  h4 = plot_dist(sample = pars$mu_beta2, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Lev 2)")))
  h5 = plot_dist(sample = pars$mu_pi, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(pi, " (Pers.)")))
  h6 = plot_dist(sample = pars$mu_w, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(omega, " (weight)")))
  h7 = plot_dist(sample = pars$mu_lambda, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(lambda, " (eligib.)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, h7, cols = ncols)
  return(h_all)
}

plot_ts_par4 <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_a, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(alpha, " (Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h3 = plot_dist(sample = pars$mu_pi, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(pi, " (Pers.)")))
  h4 = plot_dist(sample = pars$mu_w, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(omega, " (weight)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_ts_par6 <- function(obj, font_size = 10, ncols = 6, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_a1, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(alpha, " (Lev 1)")))
  h2 = plot_dist(sample = pars$mu_beta1, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Lev 1)")))
  h3 = plot_dist(sample = pars$mu_a2, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(alpha, " (Lev 2)")))
  h4 = plot_dist(sample = pars$mu_beta2, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Lev 2)")))
  h5 = plot_dist(sample = pars$mu_pi, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(pi, " (Pers.)")))
  h6 = plot_dist(sample = pars$mu_w, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(omega, " (weight)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, cols = ncols)
  return(h_all)
}

plot_wcs_sql <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_r, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(r, " (Reward Sens.)")))
  h2 = plot_dist(sample = pars$mu_p, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(p, " (Punishment Sens.)")))
  h3 = plot_dist(sample = pars$mu_d, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(d, " (Decision Consistency)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_bart_par4 <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_phi, font_size = font_size, bin_size = bin_size, x_lim = c(0,1), x_lab = expression(paste(phi, " (Prior Belief)")))
  h2 = plot_dist(sample = pars$mu_eta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(eta, " (Updating Rate)")))
  h3 = plot_dist(sample = pars$mu_gam, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(gamma, " (Risk-Taking Parameter)")))
  h4 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_rdt_happiness <- function(obj, font_size = 10, ncols = 5, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_w0, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(w[0], " (Constant)")))
  h2 = plot_dist(sample = pars$mu_w1, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(w[1], " (CR)")))
  h3 = plot_dist(sample = pars$mu_w2, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(w[2], " (EV)")))
  h4 = plot_dist(sample = pars$mu_w3, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(w[3], " (RPE)")))
  h5 = plot_dist(sample = pars$mu_gam, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(gamma, " (Forgetting)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_cra_linear <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha, " (Risk Att.)")))
  h2 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Ambiguity Att.)")))
  h3 = plot_dist(sample = pars$mu_gamma, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(gamma, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_cra_exp <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha, " (Risk Att.)")))
  h2 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Ambiguity Att.)")))
  h3 = plot_dist(sample = pars$mu_gamma, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(gamma, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_pst_gainloss_Q <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_alpha_pos, font_size = font_size, bin_size = bin_size, x_lim = c(0,2), x_lab = expression(paste(alpha[pos], " (+Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_alpha_neg, font_size = font_size, bin_size = bin_size, x_lim = c(0,2), x_lab = expression(paste(alpha[neg], " (-Learning Rate)")))
  h3 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_pstRT_ddm <- function(obj, font_size = 10, ncols = 5, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_a, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(a, " (Boundary Separation)")))
  h2 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Non-Decision Time)")))
  h3 = plot_dist(sample = pars$mu_d1, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(d1, " (Drift Rate 1)")))
  h4 = plot_dist(sample = pars$mu_d2, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(d2, " (Drift Rate 2)")))
  h5 = plot_dist(sample = pars$mu_d3, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(d3, " (Drift Rate 3)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_pstRT_rlddm1 <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_a, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(a, " (Boundary Separation)")))
  h2 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Non-Decision Time)")))
  h3 = plot_dist(sample = pars$mu_v, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(v, " (Drift Rate Scaling)")))
  h4 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha, " (Learning Rate)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_pstRT_rlddm6 <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_a, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(a, " (Boundary Baseline)")))
  h2 = plot_dist(sample = pars$mu_bp, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(bp, " (Boundary Power)")))
  h3 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Non-Decision Time)")))
  h4 = plot_dist(sample = pars$mu_v, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(v, " (Drift Rate Scaling)")))
  h5 = plot_dist(sample = pars$mu_alpha_pos, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha[pos], " (+Learning Rate)")))
  h6 = plot_dist(sample = pars$mu_alpha_neg, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(alpha[neg], " (-Learning Rate)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, cols = ncols)
  return(h_all)
}

plot_bandit4arm2_kalman_filter <- function(obj, font_size = 10, ncols = 6, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_lambda, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(lambda, " (Decay Factor)")))
  h2 = plot_dist(sample = pars$mu_theta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(theta, " (Decay Center)")))
  h3 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h4 = plot_dist(sample = pars$mu_mu0, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(mu0, " (Anticipated Initial Mean)")))
  h5 = plot_dist(sample = pars$mu_s0, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(s0, " (Anticipated Initial SD (Uncertainty))")))
  h6 = plot_dist(sample = pars$mu_sD, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(sD, " (SD of Diffusion Noise)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, cols = ncols)
  return(h_all)
}

plot_dbdm_prob_weight <- function(obj, font_size = 10, ncols = 4, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_tau, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(tau, " (Prob. Weight)")))
  h2 = plot_dist(sample = pars$mu_rho, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(rho, " (Subject Utility)")))
  h3 = plot_dist(sample = pars$mu_lambda, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(lambda, " (Loss Aversion)")))
  h4 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_bandit4arm_lapse_decay <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_Arew, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A[rew], " (Rew. Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_Apun, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A[pun], " (Pun. Learning Rate)")))
  h3 = plot_dist(sample = pars$mu_R, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(R, " (Rew. Sens.)")))
  h4 = plot_dist(sample = pars$mu_P, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(P, " (Pun. Sens.)")))
  h5 = plot_dist(sample = pars$mu_xi, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(xi, " (Noise)")))
  h6 = plot_dist(sample = pars$mu_d, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(d, " (Decay)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, cols = ncols)
  return(h_all)
}

plot_bandit4arm_singleA_lapse <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_A, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A, " (Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_R, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(R, " (Rew. Sens.)")))
  h3 = plot_dist(sample = pars$mu_P, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(P, " (Pun. Sens.)")))
  h4 = plot_dist(sample = pars$mu_xi, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(xi, " (Noise)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_bandit4arm_2par_lapse <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_Arew, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A[rew], " (Rew. Learning Rate)")))
  h2 = plot_dist(sample = pars$mu_Apun, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(A[pun], " (Pun. Learning Rate)")))
  h3 = plot_dist(sample = pars$mu_xi, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(xi, " (Noise)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_cgt_cm <- function(obj, font_size = 10, ncols = 3, bin_size = 30) {
  pars = obj$par_vals
  h1 = plot_dist(sample = pars$mu_alpha, font_size = font_size, bin_size = bin_size, x_lim = c(0, 5), x_lab = expression(paste(alpha, " (Probability Distortion)")))
  h2 = plot_dist(sample = pars$mu_c, font_size = font_size, bin_size = bin_size, x_lim = c(0, 1), x_lab = expression(paste(c, " (Color Bias)")))
  h3 = plot_dist(sample = pars$mu_rho, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(rho, " (Rel. Loss Sensitivity)")))
  h4 = plot_dist(sample = pars$mu_beta, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(beta, " (Discounting Rate)")))
  h5 = plot_dist(sample = pars$mu_gamma, font_size = font_size, bin_size = bin_size, x_lab = expression(paste(gamma, " (Choice Sensitivity)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_hgf_ibrb <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars <- obj$par_vals
  mu_kappa <- pars$mu_kappa
  mu_omega <- pars$mu_omega
  mu_zeta  <- pars$mu_zeta
  plots <- list()
  k <- 1
  if (!is.null(mu_kappa) && ncol(mu_kappa) > 0) {
    for (i in seq_len(ncol(mu_kappa))) {
      plots[[k]] <- plot_dist(
        sample   = mu_kappa[, i],
        font_size = font_size,
        bin_size  = bin_size,
        x_lab     = bquote(kappa[.(i+1)] ~ "(phasic volatility)")
      )
      k <- k + 1
    }
  }
  if (!is.null(mu_omega) && ncol(mu_omega) > 0) {
    for (i in seq_len(ncol(mu_omega))) {
      plots[[k]] <- plot_dist(
        sample   = mu_omega[, i],
        font_size = font_size,
        bin_size  = bin_size,
        x_lab     = bquote(omega[.(i+1)] ~ "(tonic volatility)")
      )
      k <- k + 1
    }
  }
  if (!is.null(mu_zeta) && length(mu_zeta) > 0) {
    plots[[k]] <- plot_dist(
      sample   = mu_zeta,
      font_size = font_size,
      bin_size  = bin_size,
      x_lab     = expression(zeta ~ "(inv. decision noise)")
    )
    k <- k + 1
  }
  h_all <- do.call(multiplot, c(plots, list(cols = ncols)))
  return(h_all)
}

plot_hgf_ibrb_single <- function(obj, font_size = 10, ncols = 2, bin_size = 30) {
  pars <- obj$par_vals
  plots <- list()
  k <- 1
  if (!is.null(pars$kappa) && ncol(pars$kappa) > 0) {
    for (i in seq_len(ncol(pars$kappa))) {
      plots[[k]] <- plot_dist(
        sample   = pars$kappa[, i],
        font_size = font_size,
        bin_size  = bin_size,
        x_lab     = bquote(kappa[.(i+1)] ~ "(phasic volatility)")
      )
      k <- k + 1
    }
  }
  if (!is.null(pars$omega) && ncol(pars$omega) > 0) {
    for (i in seq_len(ncol(pars$omega))) {
      plots[[k]] <- plot_dist(
        sample   = pars$omega[, i],
        font_size = font_size,
        bin_size  = bin_size,
        x_lab     = bquote(omega[.(i+1)] ~ "(tonic volatility)")
      )
      k <- k + 1
    }
  }
  if (!is.null(pars$zeta) && length(pars$zeta) > 0) {
    plots[[k]] <- plot_dist(
      sample   = pars$zeta,
      font_size = font_size,
      bin_size  = bin_size,
      x_lab     = expression(zeta ~ "(inv. decision noise)")
    )
    k <- k + 1
  }
  h_all <- do.call(multiplot, c(plots, list(cols = ncols)))
  return(h_all)
}
