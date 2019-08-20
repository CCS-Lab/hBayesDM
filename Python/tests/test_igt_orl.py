import pytest

from hbayesdm.models import igt_orl


def test_igt_orl():
    _ = igt_orl(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
