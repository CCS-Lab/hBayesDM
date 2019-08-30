import pytest

from hbayesdm.models import bandit4arm_singleA_lapse


def test_bandit4arm_singleA_lapse():
    _ = bandit4arm_singleA_lapse(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
