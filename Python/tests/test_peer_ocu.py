import pytest

from hbayesdm.models import peer_ocu


def test_peer_ocu():
    _ = peer_ocu(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
