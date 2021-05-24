import pytest

from hbayesdm.models import banditNarm2_kalman_filter


def test_banditNarm2_kalman_filter():
    _ = banditNarm2_kalman_filter(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
