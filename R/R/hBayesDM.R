#' @title Hierarchical Bayesian Modeling of Decision-Making Tasks
#'
#' @docType package
#' @name hBayesDM-package
#' @aliases hBayesDM
#' @useDynLib hBayesDM, .registration = TRUE
#'
#' @import methods
#' @import Rcpp
#'
#' @description
#' Fit an array of decision-making tasks with computational models in a hierarchical Bayesian framework. Can perform hierarchical Bayesian analysis of various computational models with a single line of coding.
#' Bolded tasks, followed by their respective models, are itemized below.
#'
#' \describe{
#'  \item{\strong{Bandit}}{2-Armed Bandit (Rescorla-Wagner (delta)) --- \link{bandit2arm_delta} \cr
#'                         4-Armed Bandit with fictive updating + reward/punishment sensitvity (Rescorla-Wagner (delta)) --- \link{bandit4arm_4par} \cr
#'                         4-Armed Bandit with fictive updating + reward/punishment sensitvity + lapse (Rescorla-Wagner (delta)) --- \link{bandit4arm_lapse}}
#'  \item{\strong{Bandit2}}{Kalman filter --- \link{bandit4arm2_kalman_filter}}
#'  \item{\strong{Choice RT}}{Drift Diffusion Model --- \link{choiceRT_ddm} \cr
#'                            Drift Diffusion Model for a single subject --- \link{choiceRT_ddm_single} \cr
#'                            Linear Ballistic Accumulator (LBA) model --- \link{choiceRT_lba} \cr
#'                            Linear Ballistic Accumulator (LBA) model for a single subject --- \link{choiceRT_lba_single}}
#'  \item{\strong{Choice under Risk and Ambiguity}}{Exponential model --- \link{cra_exp} \cr
#'                                                  Linear model --- \link{cra_linear}}
#'  \item{\strong{Description-Based Decision Making}}{probability weight function --- \link{dbdm_prob_weight}}
#'  \item{\strong{Delay Discounting}}{Constant Sensitivity --- \link{dd_cs} \cr
#'                                    Constant Sensitivity for a single subject --- \link{dd_cs_single} \cr
#'                                    Exponential --- \link{dd_exp} \cr
#'                                    Hyperbolic --- \link{dd_hyperbolic} \cr
#'                                    Hyperbolic for a single subject --- \link{dd_hyperbolic_single}}
#'  \item{\strong{Orthogonalized Go/Nogo}}{RW + Noise --- \link{gng_m1} \cr
#'                                         RW + Noise + Bias --- \link{gng_m2} \cr
#'                                         RW + Noise + Bias + Pavlovian Bias --- \link{gng_m3} \cr
#'                                         RW(modified) + Noise + Bias + Pavlovian Bias --- \link{gng_m4}}
#'  \item{\strong{Iowa Gambling}}{Outcome-Representation Learning --- \link{igt_orl} \cr
#'                                Prospect Valence Learning-DecayRI --- \link{igt_pvl_decay} \cr
#'                                Prospect Valence Learning-Delta --- \link{igt_pvl_delta} \cr
#'                                Value-Plus_Perseverance --- \link{igt_vpp}}
#'  \item{\strong{Peer influence task}}{OCU model --- \link{peer_ocu}}
#'  \item{\strong{Probabilistic Reversal Learning}}{Experience-Weighted Attraction --- \link{prl_ewa} \cr
#'                                                  Fictitious Update --- \link{prl_fictitious} \cr
#'                                                  Fictitious Update w/o alpha (indecision point) --- \link{prl_fictitious_woa} \cr
#'                                                  Fictitious Update and multiple blocks per subject --- \link{prl_fictitious_multipleB} \cr
#'                                                  Reward-Punishment --- \link{prl_rp} \cr
#'                                                  Reward-Punishment and multiple blocks per subject --- \link{prl_rp_multipleB} \cr
#'                                                  Fictitious Update with separate learning for Reward-Punishment --- \link{prl_fictitious_rp} \cr
#'                                                  Fictitious Update with separate learning for Reward-Punishment w/o alpha (indecision point) --- \link{prl_fictitious_rp_woa}}
#'  \item{\strong{Probabilistic Selection Task}}{Q-learning with two learning rates --- \link{pst_gainloss_Q}}
#'  \item{\strong{Risk Aversion}}{Prospect Theory (PT) --- \link{ra_prospect} \cr
#'                                PT without a loss aversion parameter --- \link{ra_noLA} \cr
#'                                PT without a risk aversion parameter --- \link{ra_noRA}}
#'  \item{\strong{Risky Decision Task}}{Happiness model --- \link{rdt_happiness}}
#'  \item{\strong{Two-Step task}}{Full model (7 parameters) --- \link{ts_par7} \cr
#'                                6 parameter model (without eligibility trace, lambda) --- \link{ts_par6} \cr
#'                                4 parameter model --- \link{ts_par4}}
#'  \item{\strong{Ultimatum Game}}{Ideal Bayesian Observer --- \link{ug_bayes} \cr
#'                                 Rescorla-Wagner (delta) --- \link{ug_delta}}
#'
#' }
#'
#' @seealso
#' For tutorials and further readings, visit : \url{http://rpubs.com/CCSL/hBayesDM}.
#'
#' @references
#' Please cite as:
#' Ahn, W.-Y., Haines, N., & Zhang, L. (2017). Revealing neuro-computational mechanisms of reinforcement learning and decision-making with the hBayesDM package. \emph{Computational Psychiatry}. 1, 24-57. https://doi.org/10.1162/CPSY_a_00002
#'
#' @author
#' Woo-Young Ahn \email{wahn55@@snu.ac.kr}
#'
#' Nathaniel Haines \email{haines.175@@osu.edu}
#'
#' Lei Zhang \email{bnuzhanglei2008@@gmail.com}
#'
NULL
