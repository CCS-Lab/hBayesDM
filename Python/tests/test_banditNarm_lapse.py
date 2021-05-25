import pytest

from hbayesdm.models import banditNarm_lapse


def test_banditNarm_lapse():
    _ = banditNarm_lapse(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
