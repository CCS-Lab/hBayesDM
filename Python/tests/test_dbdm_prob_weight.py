import pytest

from hbayesdm.models import dbdm_prob_weight


def test_dbdm_prob_weight():
    _ = dbdm_prob_weight(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
