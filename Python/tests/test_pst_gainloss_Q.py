import pytest

from hbayesdm.models import pst_gainloss_Q


def test_pst_gainloss_Q():
    _ = pst_gainloss_Q(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
