import pytest

from hbayesdm.models import bandit4arm_lapse_decay


def test_bandit4arm_lapse_decay():
    _ = bandit4arm_lapse_decay(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
