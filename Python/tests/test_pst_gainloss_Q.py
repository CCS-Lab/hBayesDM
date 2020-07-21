import pytest

from hbayesdm.models import pst_gainloss_Q


def test_pst_gainloss_Q():
    _ = pst_gainloss_Q(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
