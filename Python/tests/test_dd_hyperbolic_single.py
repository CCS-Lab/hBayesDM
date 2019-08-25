import pytest

from hbayesdm.models import dd_hyperbolic_single


def test_dd_hyperbolic_single():
    _ = dd_hyperbolic_single(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
