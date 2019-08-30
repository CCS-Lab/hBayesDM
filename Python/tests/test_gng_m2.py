import pytest

from hbayesdm.models import gng_m2


def test_gng_m2():
    _ = gng_m2(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
