import pytest

from hbayesdm.models import prl_ewa


def test_prl_ewa():
    _ = prl_ewa(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
