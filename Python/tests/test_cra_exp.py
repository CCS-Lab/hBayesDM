import pytest

from hbayesdm.models import cra_exp


def test_cra_exp():
    _ = cra_exp(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
