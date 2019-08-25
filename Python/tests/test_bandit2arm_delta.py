import pytest

from hbayesdm.models import bandit2arm_delta


def test_bandit2arm_delta():
    _ = bandit2arm_delta(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
