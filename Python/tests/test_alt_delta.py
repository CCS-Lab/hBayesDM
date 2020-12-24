import pytest

from hbayesdm.models import alt_delta


def test_alt_delta():
    _ = alt_delta(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
