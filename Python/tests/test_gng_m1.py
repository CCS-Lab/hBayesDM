import pytest

from hbayesdm.models import gng_m1


def test_gng_m1():
    _ = gng_m1(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
