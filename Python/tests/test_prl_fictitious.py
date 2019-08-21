import pytest

from hbayesdm.models import prl_fictitious


def test_prl_fictitious():
    _ = prl_fictitious(
        example=True, niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
