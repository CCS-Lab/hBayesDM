import pytest

from hbayesdm.models import prl_rp


def test_prl_rp():
    _ = prl_rp(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
