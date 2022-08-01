import pytest

from hbayesdm.models import pstRT_rlddm1


def test_pstRT_rlddm1():
    _ = pstRT_rlddm1(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
