import pytest

from hbayesdm.models import banditNarm_delta


def test_banditNarm_delta():
    _ = banditNarm_delta(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
