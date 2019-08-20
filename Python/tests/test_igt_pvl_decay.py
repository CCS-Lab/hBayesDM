import pytest

from hbayesdm.models import igt_pvl_decay


def test_igt_pvl_decay():
    _ = igt_pvl_decay(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
