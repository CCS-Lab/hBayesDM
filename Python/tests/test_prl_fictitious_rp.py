import pytest

from hbayesdm.models import prl_fictitious_rp


def test_prl_fictitious_rp():
    _ = prl_fictitious_rp(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
