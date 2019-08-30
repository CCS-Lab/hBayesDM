import pytest

from hbayesdm.models import ug_bayes


def test_ug_bayes():
    _ = ug_bayes(
        data="example", niter=10, nwarmup=5, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
