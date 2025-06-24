import pytest

from hbayesdm.models import hgf_binary_binary


def test_hgf_binary_binary():
    _ = hgf_binary_binary(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
