import pytest

from hbayesdm.models import choiceRT_ddm


def test_choiceRT_ddm():
    _ = choiceRT_ddm(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
