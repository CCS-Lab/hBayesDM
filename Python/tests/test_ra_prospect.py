import pytest

from hbayesdm.models import ra_prospect


def test_ra_prospect():
    _ = ra_prospect(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
