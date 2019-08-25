import pytest

from hbayesdm.models import bart_par4


def test_bart_par4():
    _ = bart_par4(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
