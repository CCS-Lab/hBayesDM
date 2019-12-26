import pytest

from hbayesdm.models import aversivelearning_gamma


def test_aversivelearning_gamma():
    _ = aversivelearning_gamma(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
