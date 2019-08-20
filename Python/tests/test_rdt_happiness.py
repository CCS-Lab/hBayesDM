import pytest

from hbayesdm.models import rdt_happiness


def test_rdt_happiness():
    _ = rdt_happiness(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
