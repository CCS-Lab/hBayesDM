import pytest

from hbayesdm.models import prl_fictitious_multipleB


def test_prl_fictitious_multipleB():
    _ = prl_fictitious_multipleB(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
