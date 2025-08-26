import pytest

from hbayesdm.models import hgf_ibrb


def test_hgf_ibrb():
    _ = hgf_ibrb(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
