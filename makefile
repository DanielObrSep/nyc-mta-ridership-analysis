SHELL := /bin/bash

.PHONY: env clean clean_data clean_test dbt_run dbt_test pipeline

# -------------- Reusable variance -----------------

venv := venv
activate := source $(venv)/Scripts/activate

dbt_dir := dbt_nyc_mta_ridership
seeds_dir := $(dbt_dir)/seeds
seeds := $(seeds_dir)/clean_mta_daily_ridership.csv

#----------------- fast help ----------------

help:
	@echo "Available commans"
	@echo "env					-> Create envoriment"
	@echo "clean				-> Cleaning dbt artifact"
	@echo "clean_data           -> Run clean "
	@echo "clean_test           -> Run clean test"
	@echo "dbt_run              -> Run dbt (deps, seed, run)"
	@echo "dbt_test             -> Run dbt test"
	@echo "pipeline             -> Run all (env, clean, clean_data, clean_test, dbt_run, dbt_test)"

#--------------------- Create envoriment ----------------------

env:
	@test -d $(venv) || python3 -m venv $(venv)
	@$(activate) && python -m pip install -U pip
	@$(activate) && python -m pip install -r requirements.txt
	@$(activate) && python -m pip install -r dev-requirements.txt

#------------------- Clean -----------------------

clean:
	- rm -rf $(dbt_dir)/target .pytest_cache .mypy_cache __pycache__ logs/*.log


# ---------------- Clean data -----------------------------

$(seeds_dir):
	mkdir -p $(seeds_dir)

clean_data: | $(seeds_dir)
	python scr/clean_data.py \
		--in data_raw/mta_daily_ridership.csv \
		--out $(seeds)

clean_test:
	@$(activate) && python -m pytest scr/clean_test.py 

# ---------------------- DBT -------------------------------------

dbt_run:
	dbt deps --project-dir $(dbt_dir)
	dbt seed --project-dir $(dbt_dir)
	dbt run  --project-dir $(dbt_dir)

dbt_test:
	 dbt test --project-dir $(dbt_dir)

# ------------------- Create docs & extra ---------------------------

dbt_docs:
	dbt docs generate --project-dir $(dbt_dir)
	dbt decs serve --project-dir $(dbt_dir)

dbt_clean:
	dbt clean --project-dir $(dbt_dir)

dbt_seed:
	dbt seed --project-dir $(dbt_dir)

# ------------------- Pipeline -------------------------

pipeline: env clean clean_data clean_test dbt_run dbt_test


