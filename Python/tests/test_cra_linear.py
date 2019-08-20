import pytest

from hbayesdm.models import cra_linear


def test_cra_linear():
    _ = cra_linear(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
