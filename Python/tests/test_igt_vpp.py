import pytest

from hbayesdm.models import igt_vpp


def test_igt_vpp():
    _ = igt_vpp(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
