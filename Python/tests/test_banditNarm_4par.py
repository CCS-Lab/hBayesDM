import pytest

from hbayesdm.models import banditNarm_4par


def test_banditNarm_4par():
    _ = banditNarm_4par(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
