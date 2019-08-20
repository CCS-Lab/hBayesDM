import pytest

from hbayesdm.models import prl_rp


def test_prl_rp():
    _ = prl_rp(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
