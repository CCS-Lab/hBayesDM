import pytest

from hbayesdm.models import ra_noRA


def test_ra_noRA():
    _ = ra_noRA(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
