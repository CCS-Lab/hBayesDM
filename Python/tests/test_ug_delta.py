import pytest

from hbayesdm.models import ug_delta


def test_ug_delta():
    _ = ug_delta(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
