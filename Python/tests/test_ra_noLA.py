import pytest

from hbayesdm.models import ra_noLA


def test_ra_noLA():
    _ = ra_noLA(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
