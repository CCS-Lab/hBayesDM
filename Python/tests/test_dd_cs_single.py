import pytest

from hbayesdm.models import dd_cs_single


def test_dd_cs_single():
    _ = dd_cs_single(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
