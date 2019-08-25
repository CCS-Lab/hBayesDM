import pytest

from hbayesdm.models import choiceRT_ddm_single


def test_choiceRT_ddm_single():
    _ = choiceRT_ddm_single(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
