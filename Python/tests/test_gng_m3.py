import pytest

from hbayesdm.models import gng_m3


def test_gng_m3():
    _ = gng_m3(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
