import pytest

from hbayesdm.models import ra_noRA


def test_ra_noRA():
    _ = ra_noRA(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
