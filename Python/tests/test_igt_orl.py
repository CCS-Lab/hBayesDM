import pytest

from hbayesdm.models import igt_orl


def test_igt_orl():
    _ = igt_orl(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
