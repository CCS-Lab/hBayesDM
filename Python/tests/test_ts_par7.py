import pytest

from hbayesdm.models import ts_par7


def test_ts_par7():
    _ = ts_par7(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
