import pytest

from hbayesdm.models import bandit4arm_lapse


def test_bandit4arm_lapse():
    _ = bandit4arm_lapse(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
