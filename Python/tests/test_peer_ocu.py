import pytest

from hbayesdm.models import peer_ocu


def test_peer_ocu():
    _ = peer_ocu(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
