"""User-facing API tests beyond the per-model fit smoke tests.

Fits one small hierarchical model and exercises everything the user touches
*after* the fit returns: result properties, plotting dispatch, diagnostics,
information criteria, HDI helpers.
"""
import matplotlib

matplotlib.use("Agg")  # headless

import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import pytest
from hbayesdm.diagnostics import extract_ic, hdi, plot_hdi, print_fit, rhat
from hbayesdm.models import dd_hyperbolic, gng_m1


@pytest.fixture(scope="module")
def fitted():
    # 2 chains so rhat is well-defined; enough draws for LOO Pareto smoothing.
    return dd_hyperbolic(
        data="example", niter=300, nwarmup=150, nchain=2, ncore=2)


def test_properties(fitted):
    assert fitted.model == "dd_hyperbolic"
    assert isinstance(fitted.all_ind_pars, pd.DataFrame)
    assert set(fitted.parameters_desc).issubset(set(fitted.all_ind_pars.columns))
    assert isinstance(fitted.par_vals, dict)
    assert "log_lik" in fitted.par_vals
    assert isinstance(fitted.raw_data, pd.DataFrame)
    assert fitted.fit is not None  # CmdStanMCMC


def test_idata_is_datatree(fitted):
    idata = fitted.idata
    # arviz 1.x returns an xarray DataTree; we only need posterior group access
    assert idata.__class__.__name__ == "DataTree"
    posterior = idata["posterior"].dataset
    for p in fitted.parameters_desc:
        assert f"mu_{p}" in posterior.data_vars


def test_plot_dist(fitted):
    fitted.plot(type="dist")
    plt.close("all")


def test_plot_trace(fitted):
    fitted.plot(type="trace")
    plt.close("all")


def test_plot_invalid_type(fitted):
    with pytest.raises(RuntimeError):
        fitted.plot(type="bogus")


def test_plot_ind(fitted):
    fitted.plot_ind()
    plt.close("all")


def test_rhat_dict(fitted):
    out = rhat(fitted)
    assert isinstance(out, dict)
    assert any(k.startswith("mu_") for k in out)


def test_rhat_threshold(fitted):
    out = rhat(fitted, less=1e9)
    assert isinstance(out, dict)
    assert all(isinstance(v, bool) for v in out.values())
    assert all(out.values())  # everything well under 1e9


def test_extract_ic(fitted):
    ic = extract_ic(fitted)
    assert "looic" in ic and "loo" in ic
    assert np.isfinite(ic["looic"])


def test_print_fit(fitted):
    df = print_fit(fitted)
    assert isinstance(df, pd.DataFrame)
    assert df.shape[0] == 1


def test_hdi_helper():
    rng = np.random.default_rng(0)
    samples = rng.standard_normal(2000)
    interval = hdi(samples, ci_prob=0.5)
    assert interval.shape == (2,)
    assert interval[0] < interval[1]


def test_plot_hdi_helper():
    rng = np.random.default_rng(0)
    plot_hdi(rng.standard_normal(500), ci_prob=0.8, title="hdi", xlabel="x")
    plt.close("all")


def test_model_regressor():
    """gng_m1 declares 4 regressors (Qgo, Qnogo, Wgo, Wnogo)."""
    m = gng_m1(data="example", niter=40, nwarmup=20, nchain=1, ncore=1,
               model_regressor=True)
    reg = m.model_regressor
    assert isinstance(reg, dict)
    assert set(reg) == {"Qgo", "Qnogo", "Wgo", "Wnogo"}
    for arr in reg.values():
        assert isinstance(arr, np.ndarray)
        assert arr.size > 0
        assert np.isfinite(arr).all()


def test_model_regressor_unsupported():
    """dd_hyperbolic declares no regressors; requesting them must raise."""
    with pytest.raises(RuntimeError, match="regressors"):
        dd_hyperbolic(data="example", niter=20, nwarmup=10, nchain=1,
                      ncore=1, model_regressor=True)


def test_vb_fit():
    m = dd_hyperbolic(data="example", niter=20, nwarmup=10, nchain=1,
                      ncore=1, vb=True)
    # CmdStanVB exposes stan_variables() like CmdStanMCMC.
    assert m.fit.__class__.__name__ == "CmdStanVB"
    # idata path for VB wraps stan_variables in a single-chain DataTree.
    assert m.idata.__class__.__name__ == "DataTree"
    posterior = m.idata["posterior"].dataset
    for p in m.parameters_desc:
        assert f"mu_{p}" in posterior.data_vars
    # all_ind_pars still computable from VB means.
    assert isinstance(m.all_ind_pars, pd.DataFrame)
    assert set(m.parameters_desc).issubset(set(m.all_ind_pars.columns))


if __name__ == "__main__":
    pytest.main([__file__])
