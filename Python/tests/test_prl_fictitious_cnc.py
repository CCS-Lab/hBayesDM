import pytest

from hbayesdm.models import prl_fictitious_cnc


def test_prl_fictitious_cnc():
    _ = prl_fictitious_cnc(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
