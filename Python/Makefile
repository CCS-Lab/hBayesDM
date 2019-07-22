PIPENV_PATH = $(shell which pipenv)

init:
ifeq (, $(PIPENV_PATH))
	pip install pipenv
endif
	pipenv install --dev --skip-lock

test:
	pipenv run py.test tests

test-travis:
	pipenv run py.test tests --doctest-modules

lint:
	pipenv run flake8 adopy --format=pylint --statistics --exit-zero
	pipenv run pylint adopy --rcfile=setup.cfg --exit-zero

docs-travis:
	pipenv run travis-sphinx build
	pipenv run travis-sphinx deploy

.PHONY: init test test-travis lint docs-travis
