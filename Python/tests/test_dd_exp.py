import pytest

from hbayesdm.models import dd_exp


def test_dd_exp():
    _ = dd_exp(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
