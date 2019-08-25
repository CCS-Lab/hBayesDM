import pytest

from hbayesdm.models import wcs_sql


def test_wcs_sql():
    _ = wcs_sql(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
