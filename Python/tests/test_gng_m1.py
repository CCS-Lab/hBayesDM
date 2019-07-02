import pytest

from hbayesdm.models import gng_m1


def test_gng_m1():
    fit = gng_m1(example=True, niter=200, nwarmup=100, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
