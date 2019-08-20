import pytest

from hbayesdm.models import gng_m3


def test_gng_m3():
    _ = gng_m3(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
