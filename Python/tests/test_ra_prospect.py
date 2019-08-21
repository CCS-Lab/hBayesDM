import pytest

from hbayesdm.models import ra_prospect


def test_ra_prospect():
    _ = ra_prospect(
        example=True, niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
