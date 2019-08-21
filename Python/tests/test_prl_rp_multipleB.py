import pytest

from hbayesdm.models import prl_rp_multipleB


def test_prl_rp_multipleB():
    _ = prl_rp_multipleB(
        example=True, niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
