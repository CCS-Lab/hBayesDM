import pytest
import pystan

from hbayesdm.models import gng_m1, gng_m2, gng_m3, gng_m4
from hbayesdm import rhat, print_fit


def test_gng_models():
    print(pystan.__version__)

    fit = gng_m1(example=True, niter=2000, nwarmup=1000, nchain=1, ncore=1)
    print(fit)
    print(fit.all_ind_pars)
    print(rhat(fit, less=1.1))

    fit2 = gng_m2(example=True, niter=2000, nwarmup=1000, nchain=1, ncore=1)
    fit3 = gng_m3(example=True, niter=2000, nwarmup=1000, nchain=1, ncore=1)
    fit4 = gng_m4(example=True, niter=2000, nwarmup=1000, nchain=1, ncore=1)

    print_fit(fit, fit2, fit3, fit4)  # ic='loo'
    print_fit(fit, fit2, fit3, fit4, ic='waic')


if __name__ == '__main__':
    pytest.main()
