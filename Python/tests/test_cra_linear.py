import pytest

from hbayesdm.models import cra_linear


def test_cra_linear():
    _ = cra_linear(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
