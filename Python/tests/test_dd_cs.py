import pytest

from hbayesdm.models import dd_cs


def test_dd_cs():
    _ = dd_cs(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
