import pytest

from hbayesdm.models import ra_noLA


def test_ra_noLA():
    _ = ra_noLA(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
