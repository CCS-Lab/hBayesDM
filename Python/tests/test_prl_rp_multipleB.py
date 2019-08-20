import pytest

from hbayesdm.models import prl_rp_multipleB


def test_prl_rp_multipleB():
    _ = prl_rp_multipleB(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
