import pytest

from hbayesdm.models import hgf_ibrb_single


def test_hgf_ibrb_single():
    _ = hgf_ibrb_single(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
