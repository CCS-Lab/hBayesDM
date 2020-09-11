import os

import numpy as np
import pandas as pd

from hbayesdm.base import PATH_COMMON


def alt_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    choice = np.full((n_subj, t_max), -1, dtype=int)
    outcome = np.full((n_subj, t_max), 0, dtype=float)
    blue_punish = np.full((n_subj, t_max), 0, dtype=float)
    orange_punish = np.full((n_subj, t_max), 0, dtype=float)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        choice[s][:t] = subj_data['choice']
        outcome[s][:t] = subj_data['outcome']
        blue_punish[s][:t] = subj_data['bluepunish']
        orange_punish[s][:t] = subj_data['orangepunish']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'choice': choice,
        'outcome': outcome,
        'bluePunish': blue_punish,
        'orangePunish': orange_punish,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def bandit2arm_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    choice = np.full((n_subj, t_max), -1, dtype=int)
    outcome = np.full((n_subj, t_max), 0, dtype=float)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        choice[s][:t] = subj_data['choice']
        outcome[s][:t] = subj_data['outcome']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'choice': choice,
        'outcome': outcome,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def bandit4arm_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    rew = np.full((n_subj, t_max), 0, dtype=float)
    los = np.full((n_subj, t_max), 0, dtype=float)
    choice = np.full((n_subj, t_max), -1, dtype=int)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        rew[s][:t] = subj_data['gain']
        los[s][:t] = -1 * np.abs(subj_data['loss'])  # Use abs
        choice[s][:t] = subj_data['choice']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'rew': rew,
        'los': los,
        'choice': choice,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def bandit4arm2_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    choice = np.full((n_subj, t_max), -1, dtype=int)
    outcome = np.full((n_subj, t_max), 0, dtype=float)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        choice[s][:t] = subj_data['choice']
        outcome[s][:t] = subj_data['outcome']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'choice': choice,
        'outcome': outcome,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def bart_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    pumps = np.full((n_subj, t_max), 0, dtype=int)
    explosion = np.full((n_subj, t_max), 0, dtype=int)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        pumps[s][:t] = subj_data['pumps']
        explosion[s][:t] = subj_data['explosion']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'P': np.max(pumps) + 1,
        'pumps': pumps,
        'explosion': explosion,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def choiceRT_preprocess_func(self, raw_data, general_info, additional_args):
    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']

    # Number of upper/lower boundary responses
    Nu = np.full(n_subj, 0, dtype=int)
    Nl = np.full(n_subj, 0, dtype=int)

    # Write Nu, Nl
    subj_group = iter(general_info['grouped_data'])
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        value_counts = subj_data['choice'].value_counts()
        Nu[s] = value_counts.at[2]
        Nl[s] = value_counts.at[1]

    # Reaction-times for upper/lower boundary responses
    RTu = np.full((n_subj, np.max(Nu)), -1, dtype=float)
    RTl = np.full((n_subj, np.max(Nl)), -1, dtype=float)

    # Write RTu, RTl
    subj_group = iter(general_info['grouped_data'])
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        if Nu[s] > 0:
            RTu[s][:Nu[s]] = subj_data['rt'][subj_data['choice'] == 2]
        if Nl[s] > 0:
            RTl[s][:Nl[s]] = subj_data['rt'][subj_data['choice'] == 1]

    # Minimum reaction time
    minRT = np.full(n_subj, -1, dtype=float)

    # Write minRT
    subj_group = iter(general_info['grouped_data'])
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        minRT[s] = min(subj_data['rt'])

    # Use additional_args if provided
    RTbound = additional_args.get('RTbound', 0.1)

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'Nu_max': np.max(Nu),
        'Nl_max': np.max(Nl),
        'Nu': Nu,
        'Nl': Nl,
        'RTu': RTu,
        'RTl': RTl,
        'minRT': minRT,
        'RTbound': RTbound,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def choiceRT_single_preprocess_func(self, raw_data, general_info, additional_args):
    # DataFrames per upper/lower boundary responses
    df_upper = raw_data.loc[raw_data['choice'] == 2]
    df_lower = raw_data.loc[raw_data['choice'] == 1]

    # Number of upper/lower boundary responses
    Nu = len(df_upper)
    Nl = len(df_lower)

    # Reaction-times for upper/lower boundary responses
    RTu = df_upper['rt'].to_numpy()
    RTl = df_lower['rt'].to_numpy()

    # Minimum reaction time
    minRT = min(raw_data['rt'])

    # Use additional_args if provided
    RTbound = additional_args.get('RTbound', 0.1)

    # Wrap into a dict for pystan
    data_dict = {
        'Nu': Nu,
        'Nl': Nl,
        'RTu': RTu,
        'RTl': RTl,
        'minRT': minRT,
        'RTbound': RTbound,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def cra_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    choice = np.full((n_subj, t_max), 0, dtype=int)
    prob = np.full((n_subj, t_max), 0, dtype=float)
    ambig = np.full((n_subj, t_max), 0, dtype=float)
    reward_var = np.full((n_subj, t_max), 0, dtype=float)
    reward_fix = np.full((n_subj, t_max), 0, dtype=float)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        choice[s][:t] = subj_data['choice']
        prob[s][:t] = subj_data['prob']
        ambig[s][:t] = subj_data['ambig']
        reward_var[s][:t] = subj_data['rewardvar']
        reward_fix[s][:t] = subj_data['rewardfix']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'choice': choice,
        'prob': prob,
        'ambig': ambig,
        'reward_var': reward_var,
        'reward_fix': reward_fix,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def dbdm_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    opt1hprob = np.full((n_subj, t_max), 0, dtype=float)
    opt2hprob = np.full((n_subj, t_max), 0, dtype=float)
    opt1hval = np.full((n_subj, t_max), 0, dtype=float)
    opt1lval = np.full((n_subj, t_max), 0, dtype=float)
    opt2hval = np.full((n_subj, t_max), 0, dtype=float)
    opt2lval = np.full((n_subj, t_max), 0, dtype=float)
    choice = np.full((n_subj, t_max), -1, dtype=int)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        opt1hprob[s][:t] = subj_data['opt1hprob']
        opt2hprob[s][:t] = subj_data['opt2hprob']
        opt1hval[s][:t] = subj_data['opt1hval']
        opt1lval[s][:t] = subj_data['opt1lval']
        opt2hval[s][:t] = subj_data['opt2hval']
        opt2lval[s][:t] = subj_data['opt2lval']
        choice[s][:t] = subj_data['choice']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'opt1hprob': opt1hprob,
        'opt2hprob': opt2hprob,
        'opt1hval': opt1hval,
        'opt1lval': opt1lval,
        'opt2hval': opt2hval,
        'opt2lval': opt2lval,
        'choice': choice,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def dd_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    delay_later = np.full((n_subj, t_max), 0, dtype=float)
    amount_later = np.full((n_subj, t_max), 0, dtype=float)
    delay_sooner = np.full((n_subj, t_max), 0, dtype=float)
    amount_sooner = np.full((n_subj, t_max), 0, dtype=float)
    choice = np.full((n_subj, t_max), -1, dtype=int)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        delay_later[s][:t] = subj_data['delaylater']
        amount_later[s][:t] = subj_data['amountlater']
        delay_sooner[s][:t] = subj_data['delaysooner']
        amount_sooner[s][:t] = subj_data['amountsooner']
        choice[s][:t] = subj_data['choice']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'delay_later': delay_later,
        'amount_later': amount_later,
        'delay_sooner': delay_sooner,
        'amount_sooner': amount_sooner,
        'choice': choice,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def dd_single_preprocess_func(self, raw_data, general_info, additional_args):
    # Use general_info about raw_data
    t_subjs = general_info['t_max']  # Note: use 't_max' not 't_subjs'

    # Extract from raw_data
    delay_later = raw_data['delaylater']
    amount_later = raw_data['amountlater']
    delay_sooner = raw_data['delaysooner']
    amount_sooner = raw_data['amountsooner']
    choice = raw_data['choice']

    # Wrap into a dict for pystan
    data_dict = {
        'Tsubj': t_subjs,
        'delay_later': delay_later,
        'amount_later': amount_later,
        'delay_sooner': delay_sooner,
        'amount_sooner': amount_sooner,
        'choice': choice,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def gng_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    cue = np.full((n_subj, t_max), 1, dtype=int)
    pressed = np.full((n_subj, t_max), -1, dtype=int)
    outcome = np.full((n_subj, t_max), 0, dtype=float)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        cue[s][:t] = subj_data['cue']
        pressed[s][:t] = subj_data['keypressed']
        outcome[s][:t] = subj_data['outcome']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'cue': cue,
        'pressed': pressed,
        'outcome': outcome,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def igt_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    y_data = np.full((n_subj, t_max), -1, dtype=int)
    rl_matrix = np.full((n_subj, t_max), 0, dtype=float)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        y_data[s][:t] = subj_data['choice']
        rl_matrix[s][:t] = subj_data['gain'] - np.abs(subj_data['loss'])

    # Use additional_args if provided
    payscale = additional_args.get('payscale', 100)

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'choice': y_data,
        'outcome': rl_matrix / payscale,
        'sign_out': np.sign(rl_matrix),
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def peer_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    condition = np.full((n_subj, t_max), 0, dtype=int)
    p_gamble = np.full((n_subj, t_max), 0, dtype=float)
    safe_Hpayoff = np.full((n_subj, t_max), 0, dtype=float)
    safe_Lpayoff = np.full((n_subj, t_max), 0, dtype=float)
    risky_Hpayoff = np.full((n_subj, t_max), 0, dtype=float)
    risky_Lpayoff = np.full((n_subj, t_max), 0, dtype=float)
    choice = np.full((n_subj, t_max), -1, dtype=int)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        condition[s][:t] = subj_data['condition']
        p_gamble[s][:t] = subj_data['pgamble']
        safe_Hpayoff[s][:t] = subj_data['safehpayoff']
        safe_Lpayoff[s][:t] = subj_data['safelpayoff']
        risky_Hpayoff[s][:t] = subj_data['riskyhpayoff']
        risky_Lpayoff[s][:t] = subj_data['riskylpayoff']
        choice[s][:t] = subj_data['choice']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'condition': condition,
        'p_gamble': p_gamble,
        'safe_Hpayoff': safe_Hpayoff,
        'safe_Lpayoff': safe_Lpayoff,
        'risky_Hpayoff': risky_Hpayoff,
        'risky_Lpayoff': risky_Lpayoff,
        'choice': choice,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def prl_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    choice = np.full((n_subj, t_max), -1, dtype=int)
    outcome = np.full((n_subj, t_max), 0, dtype=float)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        choice[s][:t] = subj_data['choice']
        outcome[s][:t] = np.sign(subj_data['outcome'])  # Use sign

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'choice': choice,
        'outcome': outcome,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def prl_multipleB_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_block_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    b_subjs = general_info['b_subjs']
    b_max = general_info['b_max']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    choice = np.full((n_subj, b_max, t_max), -1, dtype=int)
    outcome = np.full((n_subj, b_max, t_max), 0, dtype=float)

    # Write from subj_block_data to the data arrays
    for s in range(n_subj):
        for b in range(b_subjs[s]):
            _, subj_block_data = next(subj_block_group)
            t = t_subjs[s][b]
            choice[s][b][:t] = subj_block_data['choice']
            outcome[s][b][:t] = np.sign(subj_block_data['outcome'])  # Use sign

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'B': b_max,
        'Bsubj': b_subjs,
        'T': t_max,
        'Tsubj': t_subjs,
        'choice': choice,
        'outcome': outcome,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def pst_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    option1 = np.full((n_subj, t_max), -1, dtype=int)
    option2 = np.full((n_subj, t_max), -1, dtype=int)
    choice = np.full((n_subj, t_max), -1, dtype=int)
    reward = np.full((n_subj, t_max), -1, dtype=float)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        option1[s][:t] = subj_data['type'] // 10
        option2[s][:t] = subj_data['type'] % 10
        choice[s][:t] = subj_data['choice']
        reward[s][:t] = subj_data['reward']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'option1': option1,
        'option2': option2,
        'choice': choice,
        'reward': reward,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def ra_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    gain = np.full((n_subj, t_max), 0, dtype=float)
    loss = np.full((n_subj, t_max), 0, dtype=float)
    cert = np.full((n_subj, t_max), 0, dtype=float)
    gamble = np.full((n_subj, t_max), -1, dtype=int)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        gain[s][:t] = subj_data['gain']
        loss[s][:t] = np.abs(subj_data['loss'])  # Use abs
        cert[s][:t] = subj_data['cert']
        gamble[s][:t] = subj_data['gamble']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'gain': gain,
        'loss': loss,
        'cert': cert,
        'gamble': gamble,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def rdt_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    gain = np.full((n_subj, t_max), 0, dtype=float)
    loss = np.full((n_subj, t_max), 0, dtype=float)
    cert = np.full((n_subj, t_max), 0, dtype=float)
    type = np.full((n_subj, t_max), -1, dtype=int)
    gamble = np.full((n_subj, t_max), -1, dtype=int)
    outcome = np.full((n_subj, t_max), 0, dtype=float)
    happy = np.full((n_subj, t_max), 0, dtype=float)
    RT_happy = np.full((n_subj, t_max), 0, dtype=float)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        gain[s][:t] = subj_data['gain']
        loss[s][:t] = np.abs(subj_data['loss'])  # Use abs
        cert[s][:t] = subj_data['cert']
        type[s][:t] = subj_data['type']
        gamble[s][:t] = subj_data['gamble']
        outcome[s][:t] = subj_data['outcome']
        happy[s][:t] = subj_data['happy']
        RT_happy[s][:t] = subj_data['rthappy']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'gain': gain,
        'loss': loss,
        'cert': cert,
        'type': type,
        'gamble': gamble,
        'outcome': outcome,
        'happy': happy,
        'RT_happy': RT_happy,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict

def task2AFC_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])
    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']

    #Initialize (model-specific) data arrays
    h = np.full((n_subj), 0, dtype = int)
    f = np.full((n_subj), 0, dtype = int)
    signal = np.full((n_subj), 0, dtype = int)
    noise = np.full((n_subj), 0, dtype = int)

    #Write data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)

        for stim in subj_data['stimulus']:
            if stim == 1:
                signal[s] += 1
            elif stim == 0:
                noise[s] += 1
        for stim, resp in zip(subj_data['stimulus'], subj_data['response']):
            if stim == 1 and resp == 1:
                h[s] += 1
            elif stim == 0 and resp == 1:
                f[s] += 1

    # Wrap into a dict for pystan
    data_dict = {
        'N' : n_subj,
        'h' : h,
        'f' : f,
        'signal' : signal,
        'noise' : noise,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict

def ts_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    level1_choice = np.full((n_subj, t_max), 1, dtype=int)
    level2_choice = np.full((n_subj, t_max), 1, dtype=int)
    reward = np.full((n_subj, t_max), 0, dtype=int)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        level1_choice[s][:t] = subj_data['level1choice']
        level2_choice[s][:t] = subj_data['level2choice']
        reward[s][:t] = subj_data['reward']

    # Use additional_args if provided
    trans_prob = additional_args.get('trans_prob', 0.7)

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'level1_choice': level1_choice,
        'level2_choice': level2_choice,
        'reward': reward,
        'trans_prob': trans_prob,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def ug_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    # Initialize (model-specific) data arrays
    offer = np.full((n_subj, t_max), 0, dtype=float)
    accept = np.full((n_subj, t_max), -1, dtype=int)

    # Write from subj_data to the data arrays
    for s in range(n_subj):
        _, subj_data = next(subj_group)
        t = t_subjs[s]
        offer[s][:t] = subj_data['offer']
        accept[s][:t] = subj_data['accept']

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'offer': offer,
        'accept': accept,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def wcs_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    # t_max = general_info['t_max']
    t_max = 128

    # Read from predefined answer sheet
    answersheet = PATH_COMMON / 'extdata' / 'wcs_answersheet.txt'
    answer = pd.read_csv(
        answersheet, sep='\t', header=0, index_col=0).to_numpy() - 1

    # Initialize data arrays
    choice = np.full((n_subj, 4, t_max), 0, dtype=int)
    outcome = np.full((n_subj, t_max), -1, dtype=int)
    choice_match_att = np.full((n_subj, t_max, 1, 3), 0, dtype=int)
    deck_match_rule = np.full((t_max, 3, 4), 0, dtype=float)

    # Write choice, outcome, choice_match_att
    for s in range(n_subj):
        trials = t_subjs[s]
        _, subj_data = next(subj_group)
        subj_data_choice = subj_data['choice'].to_numpy() - 1
        subj_data_outcome = subj_data['outcome'].to_numpy()
        for t in range(trials):
            c = subj_data_choice[t]
            o = subj_data_outcome[t]
            choice[s][c][t] = 1
            outcome[s][t] = o
            choice_match_att[s][t][0][:] = (c == answer[:, t])

    # Write deck_match_rule
    for t in range(t_max):
        for r in range(3):
            deck_match_rule[t][r][answer[r][t]] = 1

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'Tsubj': t_subjs,
        'choice': choice,
        'outcome': outcome,
        'choice_match_att': choice_match_att,
        'deck_match_rule': deck_match_rule,
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict


def cgt_preprocess_func(self, raw_data, general_info, additional_args):
    # Iterate through grouped_data
    subj_group = iter(general_info['grouped_data'])

    # Use general_info(s) about raw_data
    # subjs = general_info['subjs']
    n_subj = general_info['n_subj']
    t_subjs = general_info['t_subjs']
    t_max = general_info['t_max']

    uniq_bets = np.unique(raw_data['percentagestaked'])
    n_bets = len(uniq_bets)
    bets_asc = np.sort(uniq_bets / 100)
    bets_dsc = np.flip(np.sort(uniq_bets / 100))
    bet_delay = np.arange(n_bets) / 4

    bet_time = raw_data['percentagestaked'] / 100
    for b in range(n_bets):
        bet_time[bet_time == bets_asc[b]] = b + 1
    raw_data['bet_time'] = np.where(raw_data['gambletype'] == 0,
                                    n_bets + 1 - bet_time,
                                    bet_time)

    col_chosen = np.full((n_subj, t_max), 0, dtype=int)
    bet_chosen = np.full((n_subj, t_max), 0, dtype=int)
    prop_red = np.full((n_subj, t_max), 0, dtype=float)
    prop_chosen = np.full((n_subj, t_max), 0, dtype=float)
    gain = np.full((n_subj, t_max, n_bets), 0, dtype=float)
    loss = np.full((n_subj, t_max, n_bets), 0, dtype=float)

    for s in range(n_subj):
        t = t_subjs[s]
        _, subj_data = next(subj_group)

        col_chosen[s, :t] = np.where(subj_data['redchosen'] == 1, 1, 2)
        bet_chosen[s, :t] = subj_data['bet_time']
        prop_red[s, :t] = subj_data['nredboxes'] / 10
        prop_chosen[s, :t] = np.where(subj_data['redchosen'] == 1,
                                      prop_red[s][:t],
                                      1 - prop_red[s][:t])

        for b in range(n_bets):
            gain[s, :t, b] = subj_data['trialinitialpoints'] / 100 \
                + subj_data['trialinitialpoints'] / 100 \
                * np.where(subj_data['gambletype'] == 1,
                           bets_asc[b],
                           bets_dsc[b])
            loss[s, :t, b] = subj_data['trialinitialpoints'] / 100 \
                - subj_data['trialinitialpoints'] / 100 \
                * np.where(subj_data['gambletype'] == 1,
                           bets_asc[b],
                           bets_dsc[b])

    # Remove the unnecessary intermediate column
    raw_data.drop(columns='bet_time', inplace=True)

    # Wrap into a dict for pystan
    data_dict = {
        'N': n_subj,
        'T': t_max,
        'B': n_bets,
        'Tsubj': t_subjs,
        'bet_delay': bet_delay,
        'gain': gain,
        'loss': loss,
        'prop_red': prop_red,
        'prop_chosen': prop_chosen,
        'col_chosen': col_chosen,
        'bet_chosen': bet_chosen
    }

    # Returned data_dict will directly be passed to pystan
    return data_dict
