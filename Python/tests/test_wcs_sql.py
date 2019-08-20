import pytest

from hbayesdm.models import wcs_sql


def test_wcs_sql():
    _ = wcs_sql(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
