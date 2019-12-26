import pytest

from hbayesdm.models import aversivelearning_delta


def test_aversivelearning_delta():
    _ = aversivelearning_delta(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
