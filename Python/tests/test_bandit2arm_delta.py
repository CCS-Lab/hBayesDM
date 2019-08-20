import pytest

from hbayesdm.models import bandit2arm_delta


def test_bandit2arm_delta():
    _ = bandit2arm_delta(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
