import pytest

from hbayesdm.models import ug_bayes


def test_ug_bayes():
    _ = ug_bayes(example=True, niter=2, nwarmup=1, nchain=1, ncore=1)


if __name__ == '__main__':
    pytest.main()
