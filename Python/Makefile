.PHONY: init test test-user-facing test-all lint docs clean

init:
	uv sync --all-groups
	uv run python -c "import cmdstanpy; cmdstanpy.install_cmdstan()"

test: test-user-facing

test-user-facing:
	uv run pytest tests/test_user_facing.py -v

test-all:
	uv run pytest tests --reruns 2

lint:
	uv run ruff check hbayesdm
	uv run ruff format --check hbayesdm

docs:
	uv run sphinx-build -W docs docs/_build/html

clean:
	rm -rf docs/_build .pytest_cache **/__pycache__
