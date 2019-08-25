import pytest

from hbayesdm.models import dd_cs


def test_dd_cs():
    _ = dd_cs(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
