import pytest

from hbayesdm.models import dd_hyperbolic


def test_dd_hyperbolic():
    _ = dd_hyperbolic(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
