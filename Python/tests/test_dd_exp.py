import pytest

from hbayesdm.models import dd_exp


def test_dd_exp():
    _ = dd_exp(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
