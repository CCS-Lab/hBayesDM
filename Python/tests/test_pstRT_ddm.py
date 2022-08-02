import pytest

from hbayesdm.models import pstRT_ddm


def test_pstRT_ddm():
    _ = pstRT_ddm(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
