# Plotting functions for each model 

plot_gng_m1 <- function( obj, fontSize = 10, ncols = 3, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_xi, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(xi, " (Noise)")))
  h2 = plotDist(sample = pars$mu_ep, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Effective size)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_gng_m2 <- function( obj, fontSize = 10, ncols = 4, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_xi, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(xi, " (Noise)")))
  h2 = plotDist(sample = pars$mu_ep, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plotDist(sample = pars$mu_b, fontSize = fontSize, binSize = binSize, xLab = "b (Go bias)")
  h4 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Effective size)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_gng_m3 <- function( obj, fontSize = 10, ncols = 5, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_xi, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(xi, " (Noise)")))
  h2 = plotDist(sample = pars$mu_ep, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plotDist(sample = pars$mu_b, fontSize = fontSize, binSize = binSize, xLab = "b (Go bias)")
  h4 = plotDist(sample = pars$mu_pi, fontSize = fontSize, binSize = binSize, xLab = expression(paste(pi, " (Pavlovian bias)")))
  h5 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Effective size)")))
  h_all = multiplot(h1, h2, h3, h4, h5, cols = ncols)
  return(h_all)
}

plot_gng_m4 <- function( obj, fontSize = 10, ncols = 6, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_xi, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(xi, " (Noise)")))
  h2 = plotDist(sample = pars$mu_ep, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = expression(paste(epsilon, " (Learning rate)")))
  h3 = plotDist(sample = pars$mu_b, fontSize = fontSize, binSize = binSize, xLab = "b (Go bias)")
  h4 = plotDist(sample = pars$mu_pi, fontSize = fontSize, binSize = binSize, xLab = expression(paste(pi, " (Pavlovian bias)")))
  h5 = plotDist(sample = pars$mu_rhoRew, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho[Rew], " (Rew. Sens.)")))
  h6 = plotDist(sample = pars$mu_rhoPun, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho[Pun], " (Pun. sens.)")))
  h_all = multiplot(h1, h2, h3, h4, h5, h6, cols = ncols)
  return(h_all)
}

plot_igt_pvl_decay <- function( obj, fontSize = 10, ncols = 4, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_A, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = "A (Decay Rate)")
  h2 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLim = c(0, 2), xLab = expression(paste(alpha, " (Feedback Sens.)")))
  h3 = plotDist(sample = pars$mu_cons, fontSize = fontSize, binSize = binSize, xLim = c(0,5), xLab = "c (Choice Consistency)")
  h4 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLim = c(0,10), xLab = expression(paste(lambda, " (Loss Aversion)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_igt_pvl_delta <- function( obj, fontSize = 10, ncols = 4, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_A, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = "A (Learning Rate)")
  h2 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLim = c(0, 2), xLab = expression(paste(alpha, " (Feedback Sensitivity)")))
  h3 = plotDist(sample = pars$mu_cons, fontSize = fontSize, binSize = binSize, xLim = c(0,5), xLab = "c (Choice Consistency)")
  h4 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLim = c(0,10), xLab = expression(paste(lambda, " (Loss Aversion)")))
  h_all = multiplot(h1, h2, h3, h4, cols = ncols)
  return(h_all)
}

plot_igt_vpp <- function( obj, fontSize = 10, ncols = 8, binSize = 30 ) {
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

plot_ra_noLA <- function( obj, fontSize = 10, ncols = 2, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Risk Aversion)")))
  h2 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_ra_noRA <- function( obj, fontSize = 10, ncols = 2, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLab = expression(paste(lambda, " (Loss Aversion)")))
  h2 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_ra_prospect <- function( obj, fontSize = 10, ncols = 3, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLab = expression(paste(rho, " (Risk Aversion)")))
  h2 = plotDist(sample = pars$mu_lambda, fontSize = fontSize, binSize = binSize, xLab = expression(paste(lambda, " (Loss Aversion)")))
  h3 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_bandit2arm_delta <- function( obj, fontSize = 10, ncols = 2, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_A, fontSize = fontSize, binSize = binSize, xLim = c(0, 1), xLab = "A (Learning Rate)")
  h2 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_prl_fictitious <- function( obj, fontSize = 10, ncols = 3, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_eta, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(eta, " (Learning Rate)")))
  h2 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Indecision Point)")))
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_prl_ewa <- function( obj, fontSize = 10, ncols = 3, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_phi, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(phi, " (1 - Learning Rate)")))
  h2 = plotDist(sample = pars$mu_rho, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(rho, " (Experience Decay Factor)")))
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_prl_rp <- function( obj, fontSize = 10, ncols = 3, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_Apun, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(A[pun], " (Punishment Learning Rate)")))
  h2 = plotDist(sample = pars$mu_Arew, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(A[rew], " (Reward Learning Rate)")))
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_dd_hyperbolic <- function( obj, fontSize = 10, ncols = 2, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_k, fontSize = fontSize, binSize = binSize, xLab = expression(paste(kappa, " (Discounting Rate)")))
  h2 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_dd_exp <- function( obj, fontSize = 10, ncols = 2, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_r, fontSize = fontSize, binSize = binSize, xLab = "r (Exp. Discounting Rate)")
  h2 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, cols = ncols)
  return(h_all)
}

plot_dd_cs <- function( obj, fontSize = 10, ncols = 3, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_r, fontSize = fontSize, binSize = binSize, xLab = "r (Exp. Discounting Rate)")
  h2 = plotDist(sample = pars$mu_s, fontSize = fontSize, binSize = binSize, xLab = "s (Impatience)")
  h3 = plotDist(sample = pars$mu_beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_ug_bayes <- function( obj, fontSize = 10, ncols = 3, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Envy)")))
  h2 = plotDist(sample = pars$mu_Beta, fontSize = fontSize, binSize = binSize, xLab = expression(paste(beta, " (Guilt)")) )
  h3 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")))
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}

plot_ug_delta <- function( obj, fontSize = 10, ncols = 3, binSize = 30 ) {
  pars = obj$parVals
  h1 = plotDist(sample = pars$mu_alpha, fontSize = fontSize, binSize = binSize, xLab = expression(paste(alpha, " (Envy)")))
  h2 = plotDist(sample = pars$mu_ep, fontSize = fontSize, binSize = binSize, xLim = c(0,1), xLab = expression(paste(epsilon, " (Norm Adapt. Rate)")))
  h3 = plotDist(sample = pars$mu_tau, fontSize = fontSize, binSize = binSize, xLab = expression(paste(tau, " (Inverse Temp.)")) )
  h_all = multiplot(h1, h2, h3, cols = ncols)
  return(h_all)
}


