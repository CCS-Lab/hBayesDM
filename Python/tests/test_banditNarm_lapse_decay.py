import pytest

from hbayesdm.models import banditNarm_lapse_decay


def test_banditNarm_lapse_decay():
    _ = banditNarm_lapse_decay(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
