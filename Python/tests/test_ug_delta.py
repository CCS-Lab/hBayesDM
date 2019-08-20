import pytest

from hbayesdm.models import ug_delta


def test_ug_delta():
    _ = ug_delta(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
