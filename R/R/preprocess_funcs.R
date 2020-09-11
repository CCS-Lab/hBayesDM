#' @noRd
#' @keywords internal

alt_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  choice  <- array(-1, c(n_subj, t_max))
  outcome <- array( 0, c(n_subj, t_max))
  blue_punish <- array(0, c(n_subj, t_max))
  orange_punish <- array(0, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    choice[i, 1:t]  <- DT_subj$choice
    outcome[i, 1:t] <- DT_subj$outcome
    blue_punish[i, 1:t]  <- DT_subj$bluepunish
    orange_punish[i, 1:t] <- DT_subj$orangepunish
  }

  # Wrap into a list for Stan
  data_list <- list(
    N       = n_subj,
    T       = t_max,
    Tsubj   = t_subjs,
    choice  = choice,
    outcome = outcome,
    bluePunish = blue_punish,
    orangePunish = orange_punish
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

bandit2arm_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  choice  <- array(-1, c(n_subj, t_max))
  outcome <- array( 0, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    choice[i, 1:t]  <- DT_subj$choice
    outcome[i, 1:t] <- DT_subj$outcome
  }

  # Wrap into a list for Stan
  data_list <- list(
    N       = n_subj,
    T       = t_max,
    Tsubj   = t_subjs,
    choice  = choice,
    outcome = outcome
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

bandit4arm2_preprocess_func <- function(raw_data, general_info) {
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  choice  <- array(-1, c(n_subj, t_max))
  outcome <- array( 0, c(n_subj, t_max))

  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    choice[i, 1:t]  <- DT_subj$choice
    outcome[i, 1:t] <- DT_subj$outcome
  }

  data_list <- list(
    N       = n_subj,
    T       = t_max,
    Tsubj   = t_subjs,
    choice  = choice,
    outcome = outcome
  )

  return(data_list)
}

bandit4arm_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  rew    <- array( 0, c(n_subj, t_max))
  los    <- array( 0, c(n_subj, t_max))
  choice <- array(-1, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    rew[i, 1:t]    <- DT_subj$gain
    los[i, 1:t]    <- -1 * abs(DT_subj$loss)
    choice[i, 1:t] <- DT_subj$choice
  }

  # Wrap into a list for Stan
  data_list <- list(
    N      = n_subj,
    T      = t_max,
    Tsubj  = t_subjs,
    rew    = rew,
    los    = los,
    choice = choice
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

bart_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  pumps     <- array(0, c(n_subj, t_max))
  explosion <- array(0, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    pumps[i, 1:t]     <- DT_subj$pumps
    explosion[i, 1:t] <- DT_subj$explosion
  }

  # Wrap into a list for Stan
  data_list <- list(
    N         = n_subj,
    T         = t_max,
    Tsubj     = t_subjs,
    P         = max(pumps) + 1,
    pumps     = pumps,
    explosion = explosion
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

choiceRT_preprocess_func <- function(raw_data, general_info, RTbound = 0.1) {
  # Use raw_data as a data.frame
  raw_data <- as.data.frame(raw_data)

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj

  # Number of upper and lower boundary responses
  Nu <- with(raw_data, aggregate(choice == 2, by = list(y = subjid), FUN = sum)[["x"]])
  Nl <- with(raw_data, aggregate(choice == 1, by = list(y = subjid), FUN = sum)[["x"]])

  # Reaction times for upper and lower boundary responses
  RTu <- array(-1, c(n_subj, max(Nu)))
  RTl <- array(-1, c(n_subj, max(Nl)))
  for (i in 1:n_subj) {
    subj <- subjs[i]
    subj_data <- subset(raw_data, raw_data$subjid == subj)

    if (Nu[i] > 0)
      RTu[i, 1:Nu[i]] <- subj_data$rt[subj_data$choice == 2]  # (Nu/Nl[i]+1):Nu/Nl_max will be padded with 0's
    if (Nl[i] > 0)
      RTl[i, 1:Nl[i]] <- subj_data$rt[subj_data$choice == 1]  # 0 padding is skipped in likelihood calculation
  }

  # Minimum reaction time
  minRT <- with(raw_data, aggregate(rt, by = list(y = subjid), FUN = min)[["x"]])

  # Wrap into a list for Stan
  data_list <- list(
    N       = n_subj,   # Number of subjects
    Nu_max  = max(Nu),  # Max (across subjects) number of upper boundary responses
    Nl_max  = max(Nl),  # Max (across subjects) number of lower boundary responses
    Nu      = Nu,       # Number of upper boundary responses for each subject
    Nl      = Nl,       # Number of lower boundary responses for each subject
    RTu     = RTu,      # Upper boundary response times
    RTl     = RTl,      # Lower boundary response times
    minRT   = minRT,    # Minimum RT for each subject
    RTbound = RTbound   # Lower bound of RT across all subjects (e.g., 0.1 second)
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

choiceRT_single_preprocess_func <- function(raw_data, general_info, RTbound = 0.1) {
  # Currently class(raw_data) == "data.table"

  # Data.tables for upper and lower boundary responses
  DT_upper <- raw_data[raw_data$choice == 2]
  DT_lower <- raw_data[raw_data$choice == 1]

  # Wrap into a list for Stan
  data_list <- list(
    Nu      = nrow(DT_upper),    # Number of upper boundary responses
    Nl      = nrow(DT_lower),    # Number of lower boundary responses
    RTu     = DT_upper$rt,       # Upper boundary response times
    RTl     = DT_lower$rt,       # Lower boundary response times
    minRT   = min(raw_data$rt),  # Minimum RT
    RTbound = RTbound            # Lower bound of RT (e.g., 0.1 second)
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

cra_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  choice     <- array(0, c(n_subj, t_max))
  prob       <- array(0, c(n_subj, t_max))
  ambig      <- array(0, c(n_subj, t_max))
  reward_var <- array(0, c(n_subj, t_max))
  reward_fix <- array(0, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    choice[i, 1:t]     <- DT_subj$choice
    prob[i, 1:t]       <- DT_subj$prob
    ambig[i, 1:t]      <- DT_subj$ambig
    reward_var[i, 1:t] <- DT_subj$rewardvar
    reward_fix[i, 1:t] <- DT_subj$rewardfix
  }

  # Wrap into a list for Stan
  data_list <- list(
    N          = n_subj,
    T          = t_max,
    Tsubj      = t_subjs,
    choice     = choice,
    prob       = prob,
    ambig      = ambig,
    reward_var = reward_var,
    reward_fix = reward_fix
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

dbdm_preprocess_func <- function(raw_data, general_info) {
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  opt1hprob <- array( 0, c(n_subj, t_max))
  opt2hprob <- array( 0, c(n_subj, t_max))
  opt1hval  <- array( 0, c(n_subj, t_max))
  opt1lval  <- array( 0, c(n_subj, t_max))
  opt2hval  <- array( 0, c(n_subj, t_max))
  opt2lval  <- array( 0, c(n_subj, t_max))
  choice    <- array(-1, c(n_subj, t_max))

  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    opt1hprob[i, 1:t] <- DT_subj$opt1hprob
    opt2hprob[i, 1:t] <- DT_subj$opt2hprob
    opt1hval[i, 1:t]  <- DT_subj$opt1hval
    opt1lval[i, 1:t]  <- DT_subj$opt1lval
    opt2hval[i, 1:t]  <- DT_subj$opt2hval
    opt2lval[i, 1:t]  <- DT_subj$opt2lval
    choice[i, 1:t]    <- DT_subj$choice
  }

  data_list <- list(
    N         = n_subj,
    T         = t_max,
    Tsubj     = t_subjs,
    opt1hprob = opt1hprob,
    opt2hprob = opt2hprob,
    opt1hval  = opt1hval,
    opt1lval  = opt1lval,
    opt2hval  = opt2hval,
    opt2lval  = opt2lval,
    choice    = choice
  )

  return(data_list)
}

dd_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  delay_later   <- array( 0, c(n_subj, t_max))
  amount_later  <- array( 0, c(n_subj, t_max))
  delay_sooner  <- array( 0, c(n_subj, t_max))
  amount_sooner <- array( 0, c(n_subj, t_max))
  choice        <- array(-1, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    delay_later[i, 1:t]   <- DT_subj$delaylater
    amount_later[i, 1:t]  <- DT_subj$amountlater
    delay_sooner[i, 1:t]  <- DT_subj$delaysooner
    amount_sooner[i, 1:t] <- DT_subj$amountsooner
    choice[i, 1:t]        <- DT_subj$choice
  }

  # Wrap into a list for Stan
  data_list <- list(
    N             = n_subj,
    T             = t_max,
    Tsubj         = t_subjs,
    delay_later   = delay_later,
    amount_later  = amount_later,
    delay_sooner  = delay_sooner,
    amount_sooner = amount_sooner,
    choice        = choice
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

dd_single_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  t_subjs <- general_info$t_subjs

  # Extract from raw_data
  delay_later   <- raw_data$delaylater
  amount_later  <- raw_data$amountlater
  delay_sooner  <- raw_data$delaysooner
  amount_sooner <- raw_data$amountsooner
  choice        <- raw_data$choice

  # Wrap into a list for Stan
  data_list <- list(
    Tsubj         = t_subjs,
    delay_later   = delay_later,
    amount_later  = amount_later,
    delay_sooner  = delay_sooner,
    amount_sooner = amount_sooner,
    choice        = choice
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

gng_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  cue     <- array( 1, c(n_subj, t_max))
  pressed <- array(-1, c(n_subj, t_max))
  outcome <- array( 0, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    cue[i, 1:t]     <- DT_subj$cue
    pressed[i, 1:t] <- DT_subj$keypressed
    outcome[i, 1:t] <- DT_subj$outcome
  }

  # Wrap into a list for Stan
  data_list <- list(
    N       = n_subj,
    T       = t_max,
    Tsubj   = t_subjs,
    cue     = cue,
    pressed = pressed,
    outcome = outcome
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

igt_preprocess_func <- function(raw_data, general_info, payscale = 100) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize data arrays
  Ydata    <- array(-1, c(n_subj, t_max))
  RLmatrix <- array( 0, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    Ydata[i, 1:t]    <- DT_subj$choice
    RLmatrix[i, 1:t] <- DT_subj$gain - abs(DT_subj$loss)
  }

  # Wrap into a list for Stan
  data_list <- list(
    N        = n_subj,
    T        = t_max,
    Tsubj    = t_subjs,
    choice   = Ydata,
    outcome  = RLmatrix / payscale,
    sign_out = sign(RLmatrix)
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

peer_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  condition     <- array( 0, c(n_subj, t_max))
  p_gamble      <- array( 0, c(n_subj, t_max))
  safe_Hpayoff  <- array( 0, c(n_subj, t_max))
  safe_Lpayoff  <- array( 0, c(n_subj, t_max))
  risky_Hpayoff <- array( 0, c(n_subj, t_max))
  risky_Lpayoff <- array( 0, c(n_subj, t_max))
  choice        <- array(-1, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    condition[i, 1:t]     <- DT_subj$condition
    p_gamble[i, 1:t]      <- DT_subj$pgamble
    safe_Hpayoff[i, 1:t]  <- DT_subj$safehpayoff
    safe_Lpayoff[i, 1:t]  <- DT_subj$safelpayoff
    risky_Hpayoff[i, 1:t] <- DT_subj$riskyhpayoff
    risky_Lpayoff[i, 1:t] <- DT_subj$riskylpayoff
    choice[i, 1:t]        <- DT_subj$choice
  }

  # Wrap into a list for Stan
  data_list <- list(
    N             = n_subj,
    T             = t_max,
    Tsubj         = t_subjs,
    condition     = condition,
    p_gamble      = p_gamble,
    safe_Hpayoff  = safe_Hpayoff,
    safe_Lpayoff  = safe_Lpayoff,
    risky_Hpayoff = risky_Hpayoff,
    risky_Lpayoff = risky_Lpayoff,
    choice        = choice
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

prl_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  choice  <- array(-1, c(n_subj, t_max))
  outcome <- array( 0, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    choice[i, 1:t]  <- DT_subj$choice
    outcome[i, 1:t] <- sign(DT_subj$outcome)  # use sign
  }

  # Wrap into a list for Stan
  data_list <- list(
    N       = n_subj,
    T       = t_max,
    Tsubj   = t_subjs,
    choice  = choice,
    outcome = outcome
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

prl_multipleB_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  b_subjs <- general_info$b_subjs
  b_max   <- general_info$b_max
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  choice  <- array(-1, c(n_subj, b_max, t_max))
  outcome <- array( 0, c(n_subj, b_max, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]
    blocks_of_subj <- unique(DT_subj$block)

    for (b in 1:b_subjs[i]) {
      curr_block <- blocks_of_subj[b]
      DT_curr_block <- DT_subj[DT_subj$block == curr_block]
      t <- t_subjs[i, b]

      choice[i, b, 1:t]  <- DT_curr_block$choice
      outcome[i, b, 1:t] <- sign(DT_curr_block$outcome)  # use sign
    }
  }

  # Wrap into a list for Stan
  data_list <- list(
    N       = n_subj,
    B       = b_max,
    Bsubj   = b_subjs,
    T       = t_max,
    Tsubj   = t_subjs,
    choice  = choice,
    outcome = outcome
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

pst_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  option1 <- array(-1, c(n_subj, t_max))
  option2 <- array(-1, c(n_subj, t_max))
  choice  <- array(-1, c(n_subj, t_max))
  reward  <- array(-1, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    option1[i, 1:t] <- DT_subj$type %/% 10
    option2[i, 1:t] <- DT_subj$type %% 10
    choice[i, 1:t]  <- DT_subj$choice
    reward[i, 1:t]  <- DT_subj$reward
  }

  # Wrap into a list for Stan
  data_list <- list(
    N       = n_subj,
    T       = t_max,
    Tsubj   = t_subjs,
    option1 = option1,
    option2 = option2,
    choice  = choice,
    reward  = reward
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

ra_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  gain   <- array( 0, c(n_subj, t_max))
  loss   <- array( 0, c(n_subj, t_max))
  cert   <- array( 0, c(n_subj, t_max))
  gamble <- array(-1, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    gain[i, 1:t]   <- DT_subj$gain
    loss[i, 1:t]   <- abs(DT_subj$loss)  # absolute loss amount
    cert[i, 1:t]   <- DT_subj$cert
    gamble[i, 1:t] <- DT_subj$gamble
  }

  # Wrap into a list for Stan
  data_list <- list(
    N      = n_subj,
    T      = t_max,
    Tsubj  = t_subjs,
    gain   = gain,
    loss   = loss,
    cert   = cert,
    gamble = gamble
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

rdt_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  gain     <- array( 0, c(n_subj, t_max))
  loss     <- array( 0, c(n_subj, t_max))
  cert     <- array( 0, c(n_subj, t_max))
  type     <- array(-1, c(n_subj, t_max))
  gamble   <- array(-1, c(n_subj, t_max))
  outcome  <- array( 0, c(n_subj, t_max))
  happy    <- array( 0, c(n_subj, t_max))
  RT_happy <- array( 0, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    gain[i, 1:t]     <- DT_subj$gain
    loss[i, 1:t]     <- abs(DT_subj$loss)  # absolute loss amount
    cert[i, 1:t]     <- DT_subj$cert
    type[i, 1:t]     <- DT_subj$type
    gamble[i, 1:t]   <- DT_subj$gamble
    outcome[i, 1:t]  <- DT_subj$outcome
    happy[i, 1:t]    <- DT_subj$happy
    RT_happy[i, 1:t] <- DT_subj$rthappy
  }

  # Wrap into a list for Stan
  data_list <- list(
    N        = n_subj,
    T        = t_max,
    Tsubj    = t_subjs,
    gain     = gain,
    loss     = loss,
    cert     = cert,
    type     = type,
    gamble   = gamble,
    outcome  = outcome,
    happy    = happy,
    RT_happy = RT_happy
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

task2AFC_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs <- general_info$subjs
  n_subj <- general_info$n_subj

  # Initialize (model-specific) data arrays
  signal <- array(0, c(n_subj))
  noise <- array(0, c(n_subj))
  h <- array(0, c(n_subj))
  f <- array(0, c(n_subj))


  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    subj_data <- subset(raw_data, raw_data$subjid == subj)

    signal[i] = nrow(subset(subj_data, subj_data$stimulus == 1))
    noise[i] = nrow(subset(subj_data, subj_data$stimulus == 0))
    h[i] = nrow(subset(subj_data, subj_data$stimulus ==1 & subj_data$response ==1))
    f[i] = nrow(subset(subj_data, subj_data$stimulus ==0 & subj_data$response ==1))
  }

  # Wrap into a list for Stan
  data_list <- list(
    N = n_subj,
    signal = signal,
    noise = noise,
    h = h,
    f = f
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

ts_preprocess_func <- function(raw_data, general_info, trans_prob = 0.7) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  level1_choice <- array(1, c(n_subj, t_max))
  level2_choice <- array(1, c(n_subj, t_max))
  reward        <- array(0, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    level1_choice[i, 1:t] <- DT_subj$level1choice
    level2_choice[i, 1:t] <- DT_subj$level2choice
    reward[i, 1:t]        <- DT_subj$reward
  }

  # Wrap into a list for Stan
  data_list <- list(
    N             = n_subj,
    T             = t_max,
    Tsubj         = t_subjs,
    level1_choice = level1_choice,
    level2_choice = level2_choice,
    reward        = reward,
    trans_prob    = trans_prob
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

ug_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  # Initialize (model-specific) data arrays
  offer  <- array( 0, c(n_subj, t_max))
  accept <- array(-1, c(n_subj, t_max))

  # Write from raw_data to the data arrays
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]

    offer[i, 1:t]  <- DT_subj$offer
    accept[i, 1:t] <- DT_subj$accept
  }

  # Wrap into a list for Stan
  data_list <- list(
    N      = n_subj,
    T      = t_max,
    Tsubj  = t_subjs,
    offer  = offer,
    accept = accept
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

wcs_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
#   t_max   <- general_info$t_max
  t_max   <- 128

  # Read predefined answer sheet
  answersheet <- system.file("extdata", "wcs_answersheet.txt", package = "hBayesDM")
  answer <- read.table(answersheet, header = TRUE)

  # Initialize data arrays
  choice           <- array( 0, c(n_subj, 4, t_max))
  outcome          <- array(-1, c(n_subj, t_max))
  choice_match_att <- array( 0, c(n_subj, t_max, 1, 3))  # Info about chosen deck (per each trial)
  deck_match_rule  <- array( 0, c(t_max, 3, 4))          # Info about all 4 decks (per each trial)

  # Write: choice, outcome, choice_match_att
  for (i in 1:n_subj) {
    subj <- subjs[i]
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subj]
    DT_subj_choice  <- DT_subj$choice
    DT_subj_outcome <- DT_subj$outcome

    for (tr in 1:t) {
      ch <- DT_subj_choice[tr]
      ou <- DT_subj_outcome[tr]
      choice[i, ch, tr]            <- 1
      outcome[i, tr]               <- ou
      choice_match_att[i, tr, 1, ] <- answer[, tr] == ch
    }
  }

  # Write: deck_match_rule
  for (tr in 1:t_max) {
    for (ru in 1:3) {
      deck_match_rule[tr, ru, answer[ru, tr]] <- 1
    }
  }

  # Wrap into a list for Stan
  data_list <- list(
    N                = n_subj,
    T                = t_max,
    Tsubj            = t_subjs,
    choice           = choice,
    outcome          = outcome,
    choice_match_att = choice_match_att,
    deck_match_rule  = deck_match_rule
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}

cgt_preprocess_func <- function(raw_data, general_info) {
  # Currently class(raw_data) == "data.table"

  # Use general_info of raw_data
  subjs   <- general_info$subjs
  n_subj  <- general_info$n_subj
  t_subjs <- general_info$t_subjs
  t_max   <- general_info$t_max

  uniq_bet <- unique(raw_data$percentagestaked)
  n_bets <- length(uniq_bet)
  bets_asc  <- sort(uniq_bet / 100)
  bets_dsc  <- sort(uniq_bet / 100, decreasing = T)
  bet_delay <- (1:n_bets - 1) / 4

  bet_time <- raw_data$percentagestaked / 100
  for (b in 1:n_bets) {
    bet_time[bet_time == bets_asc[b]] <- b
  }
  raw_data$bet_time <- ifelse(raw_data$gambletype == 0,
                              n_bets + 1 - bet_time,
                              bet_time)

  col_chosen <- array(0, c(n_subj, t_max))
  bet_chosen <- array(0, c(n_subj, t_max))
  prop_red <- array(0, c(n_subj, t_max))
  prop_chosen <- array(0, c(n_subj, t_max))
  gain <- array(0, c(n_subj, t_max, n_bets))
  loss <- array(0, c(n_subj, t_max, n_bets))

  for (i in 1:n_subj) {
    t <- t_subjs[i]
    DT_subj <- raw_data[raw_data$subjid == subjs[i]]

    col_chosen [i, 1:t] <- ifelse(DT_subj$redchosen == 1, 1, 2)
    bet_chosen [i, 1:t] <- DT_subj$bet_time
    prop_red   [i, 1:t] <- DT_subj$nredboxes / 10
    prop_chosen[i, 1:t] <- ifelse(DT_subj$redchosen == 1,
                                  prop_red[i, 1:t],
                                  1 - prop_red[i, 1:t])

    for (b in 1:n_bets) {
      gain[i, 1:t, b] <- with(DT_subj, trialinitialpoints / 100 + trialinitialpoints / 100 * ifelse(gambletype == 1, bets_asc[b], bets_dsc[b]))
      loss[i, 1:t, b] <- with(DT_subj, trialinitialpoints / 100 - trialinitialpoints / 100 * ifelse(gambletype == 1, bets_asc[b], bets_dsc[b]))
    }
  }

  # Wrap into a list for Stan
  data_list <- list(
    N           = n_subj,
    T           = t_max,
    B           = n_bets,
    Tsubj       = t_subjs,
    bet_delay   = bet_delay,
    gain        = gain,
    loss        = loss,
    prop_red    = prop_red,
    prop_chosen = prop_chosen,
    col_chosen  = col_chosen,
    bet_chosen  = bet_chosen
  )

  # Returned data_list will directly be passed to Stan
  return(data_list)
}
