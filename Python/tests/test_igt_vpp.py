import pytest

from hbayesdm.models import igt_vpp


def test_igt_vpp():
    _ = igt_vpp(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
