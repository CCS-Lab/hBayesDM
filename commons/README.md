# hBayesDM core files

- **`extdata/`: example data for each task**
    - `{task_name}[_{model_type}]_exampleData.txt`
- **`models/`: YAML files for model information**
    - `{task_name}_{model_name}[_{model_type}].yml`
- **`stan_files/`: Stan files corresponding to YAML files**
    - `{task_name}_{model_name}[_{model_type}].stan`
- **`templates/`: code templates for R and Python package**
    - `PY_CODE_TEMPLATE.txt`
    - `PY_DOCS_TEMPLATE.txt`
    - `PY_TEST_TEMPLATE.txt`
    - `R_CODE_TEMPLATE.txt`
    - `R_DOCS_TEMPLATE.txt`
    - `R_TEST_TEMPLATE.txt`

## How to add a model

1. **Clone the repository and make new branch from `develop`.**
```bash
# Clone the repository
git clone https://github.com/CCS-Lab/hBayesDM
cd hbayesdm

git checkout develop  # Check out the develop branch
git checkout -b feature/{branch_name}  # Make new branch from develop
```
2. **Write a Stan code and a YAML file for model information, and append its example data.
You can check out [an example YAML file](./example.yml) for model information.**
    - `/commons/stan_files/{task_name}_{model_name}[_{model_type}].stan`
    - `/commons/models/{task_name}_{model_name}[_{model_type}].yml`
    - `/commons/extdata/{task_name}[_{model_type}]_exampleData.txt`
3. **Run `/commons/generate-codes.sh` to generate R and Python codes. Note that your Python
version should be above 3.5, and [`PyYAML`][pyyaml] should be pre-installed.**
```bash
cd commons
./generate-codes.sh
```
4. **Implement a function to preprocess data for the model.**
    - R: `/R/R/preprocess_funcs.R`
    - Python: `/Python/hbayesdm/preprocess_funcs.R`
5. **(For R) Run `devtools::document()` to apply the new function.**
```bash
cd ../R
Rscript -e 'devtools::document()'
```
6. **Install R and Python packages.**
```bash
# For R
cd ../R
Rscript -e 'devtools::install()'

# For Python
cd ../Python
python setup.py install
```

[pyyaml]: https://pyyaml.org/wiki/PyYAMLDocumentation
