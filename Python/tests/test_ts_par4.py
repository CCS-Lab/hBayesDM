import pytest

from hbayesdm.models import ts_par4


def test_ts_par4():
    _ = ts_par4(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
