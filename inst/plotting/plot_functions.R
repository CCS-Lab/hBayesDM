# Plotting functions for each model

plot_gng_m1 <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_xi, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(xi, " (Noise)")))
  h2 = plotDist(sample = pars$mu_ep, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Effective size)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_gng_m2 <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_xi, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(xi, " (Noise)")))
  h2 = plotDist(sample = pars$mu_ep, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plotDist(sample = pars$mu_b, fontSize = fontSize, binSize = binSize, xLab = "b (Go bias)")
  h4 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Effective size)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_gng_m3 <- function(obj, fontSize = 10, ncols = 5, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_xi, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(xi, " (Noise)")))
  h2 = plotDist(sample = pars$mu_ep, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plotDist(sample = pars$mu_b, fontSize = fontSize, binSize = binSize, xLab = "b (Go bias)")
  h4 = plotDist(sample = pars$mu_pi, fontSize = fontSize, binSize = binSize, xLab = expression(paste(pi, " (Pavlovian bias)")))
  h5 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Effective size)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_gng_m4 <- function(obj, fontSize = 10, ncols = 6, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_xi, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(xi, " (Noise)")))
  h2 = plotDist(sample = pars$mu_ep, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plotDist(sample = pars$mu_b, fontSize = fontSize, binSize = binSize, xLab = "b (Go bias)")
  h4 = plotDist(sample = pars$mu_pi, fontSize = fontSize, binSize = binSize, xLab = expression(paste(pi, " (Pavlovian bias)")))
  h5 = plotDist(sample = pars$mu_rhoRew, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho[Rew], " (Rew. Sens.)")))
  h6 = plotDist(sample = pars$mu_rhoPun, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho[Pun], " (Pun. Sens.)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, cols = ncols)
  return(h_all)
}

plot_igt_pvl_decay <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_A, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = "A (Decay Rate)")
  h2 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLim = c(0, 2), xLab = expression(paste(alpha, " (Feedback Sens.)")))
  h3 = plotDist(sample = pars$mu_cons, fontSize = fontSize, binSize = binSize, xLim = c(0,5), xLab = "c (Choice Consistency)")
  h4 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLim = c(0,10), xLab = expression(paste(lambda, " (Loss Aversion)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_igt_pvl_delta <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_A, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = "A (Learning Rate)")
  h2 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLim = c(0, 2), xLab = expression(paste(alpha, " (Feedback Sens.)")))
  h3 = plotDist(sample = pars$mu_cons, fontSize = fontSize, binSize = binSize, xLim = c(0,5), xLab = "c (Choice Consistency)")
  h4 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLim = c(0,10), xLab = expression(paste(lambda, " (Loss Aversion)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_igt_vpp <- function(obj, fontSize = 10, ncols = 8, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_A, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = "A (Learning Rate)")
  h2 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLim = c(0, 2), xLab = expression(paste(alpha, " (Feedback Sens.)")))
  h3 = plotDist(sample = pars$mu_cons, fontSize = fontSize, binSize = binSize, xLim = c(0,5), xLab = "c (Choice Consistency)")
  h4 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLim = c(0,10), xLab = expression(paste(lambda, " (Loss Aversion)")))
  h5 = plotDist(sample = pars$mu_epP, fontSize = fontSize, binSize = binSize, xLab = expression(paste(epsilon[P], " (Gain Impact)")))
  h6 = plotDist(sample = pars$mu_epN, fontSize = fontSize, binSize = binSize, xLab = expression(paste(epsilon[N], " (Loss Impact)")))
  h7 = plotDist(sample = pars$mu_K, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(kappa, " (Decay Rate)")))
  h8 = plotDist(sample = pars$mu_w, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(omega, " (RL Weight)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, h7, h8, cols = ncols)
  return(h_all)
}

plot_igt_orl <- function(obj, fontSize = 10, ncols = 5, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_Arew, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(A[Rew], " (Rew. Learning Rate)")))
  h2 = plotDist(sample = pars$mu_Apun, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(A[Pun], " (Pun. Learning Rate)")))
  h3 = plotDist(sample = pars$mu_K, fontSize = fontSize, binSize = binSize, xLim = c(0,5), xLab = expression(paste(K, " (Perseverance Decay)")))
  h4 = plotDist(sample = pars$mu_betaF, fontSize = fontSize, binSize = binSize, xLim = c(-10,10), xLab = expression(paste(beta[F], " (Outcome Frequency Weight)")))
  h5 = plotDist(sample = pars$mu_betaP, fontSize = fontSize, binSize = binSize, xLim = c(-10,10), xLab = expression(paste(beta[P], " (Perseverance Weight)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_ra_noLA <- function(obj, fontSize = 10, ncols = 2, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Risk Aversion)")))
  h2 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_ra_noRA <- function(obj, fontSize = 10, ncols = 2, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLab = expression(paste(lambda, " (Loss Aversion)")))
  h2 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_ra_prospect <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Risk Aversion)")))
  h2 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLab = expression(paste(lambda, " (Loss Aversion)")))
  h3 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_bandit2arm_delta <- function(obj, fontSize = 10, ncols = 2, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_A, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = "A (Learning Rate)")
  h2 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_bandit4arm_4par <- function(obj, fontSize = 10, ncols = 2, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_Arew, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(A[rew], " (Rew. Learning Rate)")))
  h2 = plotDist(sample = pars$mu_Apun, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(A[pun], " (Pun. Learning Rate)")))
  h3 = plotDist(sample = pars$mu_R, fontSize = fontSize, binSize = binSize, xLab = expression(paste(R, " (Rew. Sens.)")))
  h4 = plotDist(sample = pars$mu_P, fontSize = fontSize, binSize = binSize, xLab = expression(paste(P, " (Pun. Sens.)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_bandit4arm_lapse <- function(obj, fontSize = 10, ncols = 2, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_Arew, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(A[rew], " (Rew. Learning Rate)")))
  h2 = plotDist(sample = pars$mu_Apun, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(A[pun], " (Pun. Learning Rate)")))
  h3 = plotDist(sample = pars$mu_R, fontSize = fontSize, binSize = binSize, xLab = expression(paste(R, " (Rew. Sens.)")))
  h4 = plotDist(sample = pars$mu_P, fontSize = fontSize, binSize = binSize, xLab = expression(paste(P, " (Pun. Sens.)")))
  h5 = plotDist(sample = pars$mu_xi, fontSize = fontSize, binSize = binSize, xLab = expression(paste(xi, " (Noise)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_prl_ewa <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_phi, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(phi, " (1 - Learning Rate)")))
  h2 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(rho, " (Experience Decay Factor)")))
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_prl_fictitious <- plot_prl_fictitious_multipleB <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_eta, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(eta, " (Learning Rate)")))
  h2 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Indecision Point)")))
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_prl_fictitious_rp <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_eta_pos, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(eta[p], " (+Learning Rate)")))
  h2 = plotDist(sample = pars$mu_eta_neg, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(eta[n], " (-Learning Rate)")))
  h3 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Indecision Point)")))
  h4 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_prl_fictitious_rp_woa <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_eta_pos, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(eta[p], " (+Learning Rate)")))
  h2 = plotDist(sample = pars$mu_eta_neg, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(eta[n], " (-Learning Rate)")))
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_prl_fictitious_woa <- function(obj, fontSize = 10, ncols = 2, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_eta, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(eta, " (Learning Rate)")))
  h2 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_prl_rp <- plot_prl_rp_multipleB <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_Apun, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(A[pun], " (Pun. Learning Rate)")))
  h2 = plotDist(sample = pars$mu_Arew, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(A[rew], " (Rew. Learning Rate)")))
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_dd_hyperbolic <- function(obj, fontSize = 10, ncols = 2, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_k, fontSize = fontSize, binSize = binSize, xLab = expression(paste(kappa, " (Discounting Rate)")))
  h2 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_dd_hyperbolic_single <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$k, fontSize = fontSize, binSize = binSize, xLab = expression(paste(kappa, " (Discounting Rate)")))
  h2 = plotDist(sample = pars$logK, fontSize = fontSize, binSize = binSize, xLab = expression(paste("log(", kappa, ")")))
  h3 = plotDist(sample = pars$beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_dd_exp <- function(obj, fontSize = 10, ncols = 2, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_r, fontSize = fontSize, binSize = binSize, xLab = "r (Exp. Discounting Rate)")
  h2 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_dd_cs <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_r, fontSize = fontSize, binSize = binSize, xLab = "r (Exp. Discounting Rate)")
  h2 = plotDist(sample = pars$mu_s, fontSize = fontSize, binSize = binSize, xLab = "s (Impatience)")
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_dd_cs_single <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$r, fontSize = fontSize, binSize = binSize, xLab = "r (Exp. Discounting Rate)")
  h2 = plotDist(sample = pars$logR, fontSize = fontSize, binSize = binSize, xLab = "log(r)")
  h3 = plotDist(sample = pars$s, fontSize = fontSize, binSize = binSize, xLab = "s (Impatience)")
  h4 = plotDist(sample = pars$beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_ug_bayes <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Envy)")))
  h2 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Guilt)")))
  h3 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_ug_delta <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Envy)")))
  h2 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h3 = plotDist(sample = pars$mu_ep, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(epsilon, " (Norm Adapt. Rate)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_choiceRT_ddm_single <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Boundary)")))
  h2 = plotDist(sample = pars$beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Bias)")))
  h3 = plotDist(sample = pars$delta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(delta, " (Drift rate)")))
  h4 = plotDist(sample = pars$tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Non-DM time)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_choiceRT_ddm <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Boundary)")))
  h2 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Bias)")))
  h3 = plotDist(sample = pars$mu_delta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(delta, " (Drift rate)")))
  h4 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Non-DM time)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_choiceRT_lba_single <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$d, fontSize = fontSize, binSize = binSize, xLab = expression(paste(d, " (Boundary)")))
  h2 = plotDist(sample = pars$A, fontSize = fontSize, binSize = binSize, xLab = expression(paste(A, " (Start Point)")))
  h3 = list()
  for (cd in 1:dim(pars$v)[2]) {
    for (ch in 1:dim(pars$v)[3]) {
      h3[[paste0(cd,"-",ch)]] = plotDist(sample = pars$v[,cd,ch], fontSize = fontSize, binSize = binSize, xLab = bquote(v[.(cd)-.(ch)] ~ Drift ~ Rate))
    }
  }
  my_plots = list(h1,h2)
  for (i in 1:length(h3)) my_plots[[length(my_plots) + 1]] = h3[[i]]
  my_plots[[length(my_plots) + 1]] = plotDist(sample = pars$tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Non-DM time)")))
  h_all = multiplot(plots = my_plots, cols = ncols)
  cat("Drift rates (v) are numbered as follows: v[condition-choice]. For example, v[1-2] refers to the drift rate estimate for when choice == 2 and condition == 1.")
  return(h_all)
}

plot_choiceRT_lba <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_d, fontSize = fontSize, binSize = binSize, xLab = expression(paste(d, " (Boundary)")))
  h2 = plotDist(sample = pars$mu_A, fontSize = fontSize, binSize = binSize, xLab = expression(paste(A, " (Start Point)")))
  h3 = list()
  for (cd in 1:dim(pars$mu_v)[2]) {
    for (ch in 1:dim(pars$mu_v)[3]) {
      h3[[paste0(cd,"-",ch)]] = plotDist(sample = pars$mu_v[,cd,ch], fontSize = fontSize, binSize = binSize, xLab = bquote(v[.(cd)-.(ch)] ~ Drift ~ Rate))
    }
  }
  my_plots = list(h1,h2)
  for (i in 1:length(h3)) my_plots[[length(my_plots) + 1]] = h3[[i]]
  my_plots[[length(my_plots) + 1]] = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Non-DM time)")))
  h_all = multiplot(plots = my_plots, cols = ncols)
  cat("Drift rates (v) are numbered as follows: v[condition-choice]. For example, v[1-2] refers to the drift rate estimate for when choice == 2 and condition == 1.")
  return(h_all)
}

plot_peer_ocu <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Risk Pref.)")))
  h2 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h3 = plotDist(sample = pars$mu_ocu, fontSize = fontSize, binSize = binSize, xLab = "OCU")
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_ts_par7 <- function(obj, fontSize = 10, ncols = 7, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_a1, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(alpha, " (Lev 1)")))
  h2 = plotDist(sample = pars$mu_beta1, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Lev 1)")))
  h3 = plotDist(sample = pars$mu_a2, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(alpha, " (Lev 2)")))
  h4 = plotDist(sample = pars$mu_beta2, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Lev 2)")))
  h5 = plotDist(sample = pars$mu_pi, fontSize = fontSize, binSize = binSize, xLab = expression(paste(pi, " (Pers.)")))
  h6 = plotDist(sample = pars$mu_w, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(omega, " (weight)")))
  h7 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(lambda, " (eligib.)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, h7, cols = ncols)
  return(h_all)
}

plot_ts_par4 <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_a, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(alpha, " (Learning Rate)")))
  h2 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h3 = plotDist(sample = pars$mu_pi, fontSize = fontSize, binSize = binSize, xLab = expression(paste(pi, " (Pers.)")))
  h4 = plotDist(sample = pars$mu_w, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(omega, " (weight)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_ts_par6 <- function(obj, fontSize = 10, ncols = 6, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_a1, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(alpha, " (Lev 1)")))
  h2 = plotDist(sample = pars$mu_beta1, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Lev 1)")))
  h3 = plotDist(sample = pars$mu_a2, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(alpha, " (Lev 2)")))
  h4 = plotDist(sample = pars$mu_beta2, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Lev 2)")))
  h5 = plotDist(sample = pars$mu_pi, fontSize = fontSize, binSize = binSize, xLab = expression(paste(pi, " (Pers.)")))
  h6 = plotDist(sample = pars$mu_w, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(omega, " (weight)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, cols = ncols)
  return(h_all)
}

plot_wcs_sql <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_r, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(r, " (Reward Sens.)")))
  h2 = plotDist(sample = pars$mu_p, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(p, " (Punishment Sens.)")))
  h3 = plotDist(sample = pars$mu_d, fontSize = fontSize, binSize = binSize, xLab = expression(paste(d, " (Decision Consistency)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_bart_par4 <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_phi, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(phi, " (Prior Belief)")))
  h2 = plotDist(sample = pars$mu_eta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(eta, " (Updating Rate)")))
  h3 = plotDist(sample = pars$mu_gam, fontSize = fontSize, binSize = binSize, xLab = expression(paste(gamma, " (Risk-Taking Parameter)")))
  h4 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_rdt_happiness <- function(obj, fontSize = 10, ncols = 5, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_w0, fontSize = fontSize, binSize = binSize, xLab = expression(paste(w[0], " (Constant)")))
  h2 = plotDist(sample = pars$mu_w1, fontSize = fontSize, binSize = binSize, xLab = expression(paste(w[1], " (CR)")))
  h3 = plotDist(sample = pars$mu_w2, fontSize = fontSize, binSize = binSize, xLab = expression(paste(w[2], " (EV)")))
  h4 = plotDist(sample = pars$mu_w3, fontSize = fontSize, binSize = binSize, xLab = expression(paste(w[3], " (RPE)")))
  h5 = plotDist(sample = pars$mu_gam, fontSize = fontSize, binSize = binSize, xLab = expression(paste(gamma, " (Forgetting)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_cra_linear <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Risk Att.)")))
  h2 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Ambiguity Att.)")))
  h3 = plotDist(sample = pars$mu_gamma, fontSize = fontSize, binSize = binSize, xLab = expression(paste(gamma, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_cra_exp <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Risk Att.)")))
  h2 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Ambiguity Att.)")))
  h3 = plotDist(sample = pars$mu_gamma, fontSize = fontSize, binSize = binSize, xLab = expression(paste(gamma, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_pst_gainloss_Q <- function(obj, fontSize = 10, ncols = 3, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_alpha_pos, fontSize = fontSize, binSize = binSize, xLim = c(0,2), xLab = expression(paste(alpha[pos], " (+Learning Rate)")))
  h2 = plotDist(sample = pars$mu_alpha_neg, fontSize = fontSize, binSize = binSize, xLim = c(0,2), xLab = expression(paste(alpha[neg], " (-Learning Rate)")))
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_bandit4arm2_kalman_filter <- function(obj, fontSize = 10, ncols = 6, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLab = expression(paste(lambda, " (Decay Factor)")))
  h2 = plotDist(sample = pars$mu_theta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(theta, " (Decay Center)")))
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h4 = plotDist(sample = pars$mu_mu0, fontSize = fontSize, binSize = binSize, xLab = expression(paste(mu0, " (Anticipated Initial Mean)")))
  h5 = plotDist(sample = pars$mu_sigma0, fontSize = fontSize, binSize = binSize, xLab = expression(paste(sigma0, " (Anticipated Initial SD (Uncertainty))")))
  h6 = plotDist(sample = pars$mu_sigmaD, fontSize = fontSize, binSize = binSize, xLab = expression(paste(sigmaD, " (SD of Diffusion Noise)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, cols = ncols)
  return(h_all)
}

plot_dbdm_prob_weight <- function(obj, fontSize = 10, ncols = 4, binSize = 30) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Prob. Weight)")))
  h2 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Subject Utility)")))
  h3 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLab = expression(paste(lambda, " (Loss Aversion)")))
  h4 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}
