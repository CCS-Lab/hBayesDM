import pytest

from hbayesdm.models import pstRT_rlddm6


def test_pstRT_rlddm6():
    _ = pstRT_rlddm6(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
