import pytest

from hbayesdm.models import bart_ewmv


def test_bart_ewmv():
    _ = bart_ewmv(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
