import pytest

from hbayesdm.models import prl_ewa


def test_prl_ewa():
    _ = prl_ewa(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
