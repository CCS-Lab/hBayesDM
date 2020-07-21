import pytest

from hbayesdm.models import bandit4arm_4par


def test_bandit4arm_4par():
    _ = bandit4arm_4par(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
