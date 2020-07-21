import pytest

from hbayesdm.models import gng_m4


def test_gng_m4():
    _ = gng_m4(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
