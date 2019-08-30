import pytest

from hbayesdm.models import rdt_happiness


def test_rdt_happiness():
    _ = rdt_happiness(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
