import pytest

from hbayesdm.models import cgt_cm


def test_cgt_cm():
    _ = cgt_cm(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
