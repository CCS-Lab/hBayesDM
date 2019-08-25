import pytest

from hbayesdm.models import prl_fictitious_rp_woa


def test_prl_fictitious_rp_woa():
    _ = prl_fictitious_rp_woa(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
