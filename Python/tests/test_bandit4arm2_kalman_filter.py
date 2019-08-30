import pytest

from hbayesdm.models import bandit4arm2_kalman_filter


def test_bandit4arm2_kalman_filter():
    _ = bandit4arm2_kalman_filter(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
