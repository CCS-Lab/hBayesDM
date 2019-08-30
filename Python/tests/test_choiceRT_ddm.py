import pytest

from hbayesdm.models import choiceRT_ddm


def test_choiceRT_ddm():
    _ = choiceRT_ddm(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
