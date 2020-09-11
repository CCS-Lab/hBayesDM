import pytest

from hbayesdm.models import alt_gamma


def test_alt_gamma():
    _ = alt_gamma(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
