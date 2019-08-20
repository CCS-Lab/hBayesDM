import pytest

from hbayesdm.models import dbdm_prob_weight


def test_dbdm_prob_weight():
    _ = dbdm_prob_weight(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
