import pytest

from hbayesdm.models import prl_fictitious_woa_multipleB


def test_prl_fictitious_woa_multipleB():
    _ = prl_fictitious_woa_multipleB(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
