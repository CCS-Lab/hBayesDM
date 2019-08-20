import pytest

from hbayesdm.models import ts_par6


def test_ts_par6():
    _ = ts_par6(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
