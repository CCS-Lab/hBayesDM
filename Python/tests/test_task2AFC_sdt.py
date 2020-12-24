import pytest

from hbayesdm.models import task2AFC_sdt


def test_task2AFC_sdt():
    _ = task2AFC_sdt(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
