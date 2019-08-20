import pytest

from hbayesdm.models import prl_fictitious_woa


def test_prl_fictitious_woa():
    _ = prl_fictitious_woa(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
