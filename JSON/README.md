# Model Information JSON Files

Contributed by [Jethro Lee][jethro-lee].

[jethro-lee]: https://github.com/dlemfh

## JSON Schema

Schema for the Model Information JSON files is stored in `ModelInformation.schema.json` as a JSON Schema format.

| Property          | Type                | Description
|-------------------|---------------------|----------------------------------|
| `task_name`       | Object              | Informations regarding the task. *See below for **Keys** and **Values**.*
| `model_name`      | Object              | Informations regarding the model. *See below for **Keys** and **Values**.*
| `model_type`      | Object              | Modeling-type information. Should be one of the following three:</br> - `{"code": "", "desc": "Hierarchical"}`</br> - `{"code": "single", "desc": "Individual"}`</br> - `{"code": "multipleB", "desc": "Multiple-Block Hierarchical"}`
| `notes`           | Array of Strings    | Optional notes about the task/model. Give empty array `[]` if unused.
| `contributors`    | Array of Objects    | Optional specifying of contributors. Give empty array `[]` if unused.
| `data_columns`    | Object              | **Keys**: names of the necessary data columns for user data.</br> - `"subjID"` must always be included.</br> - Also include `"block"`, if modeling-type is "multipleB".</br> **Values**: one-line descriptions about each data column.
| `parameters`      | Object (of Objects) | **Keys**: names of the parameters of this model.</br> **Values**: inner-level Object specifying desc and info for each parameter.
| `regressors`      | Object              | *(Give empty object `{}` if not supported.)*</br> **Keys**: names of the regressors of this model.</br> **Values**: extracted dimension-size for each regressor.
| `postpreds`       | Array of Strings    | Name(s) of posterior predictions. Give empty array `[]` if not supported.
| `additional_args` | Array of Objects    | Specifying of additional arguments, if any. Give empty array `[]` if unused.

*\* Note that all outermost-level properties are required properties. Assign empty values (`[]` or `{}`) to them if unused.*  
*\* Refer below for inner-level Object specifications.*

<details><summary><b><code>task_name</code> & <code>model_name</code> Object</b></summary><p>

| Keys     | Values
|----------|-------------------------------------|
| `"code"` | *(String)* Code for the task/model.
| `"desc"` | *(String)* Name of the task/model in title-case.
| `"cite"` | *(Array of Strings)* Citation(s) for the task/model.

</p></details>

<details><summary><b><code>model_type</code> Object</b></summary><p>

One of the following three:

```json
{
  "code": "",
  "desc": "Hierarchical"
}
```
```json
{
  "code": "single",
  "desc": "Individual"
}
```
```json
{
  "code": "multipleB",
  "desc": "Multiple-Block Hierarchical"
}
```

</p></details>

<details><summary><b>(Inner-level) Contributor Object</b></summary><p>

| Keys      | Values
|-----------|-------------------------------------|
| `"name"`  | *(String)* Name of the contributor.
| `"email"` | *(String)* Email address of the contributor.
| `"link"`  | *(String)* Link to the contributor's page.

</p></details>

<details><summary><b>(Inner-level) Parameter Object</b></summary><p>

| Keys     | Values
|----------|---------------------------------------------------------|
| `"desc"` | *(String)* Description of the parameter in a few words.
| `"info"` | *(Length-3-Array)* **Lower bound**, **plausible value**, and **upper bound** of the parameter.</br> *\* See right below for allowed values.*

*\* Allowed values (lower bound, plausible value, upper bound):*
- Numbers
- Strings: `"Inf"`, `"-Inf"`, `"exp([0-9.]+)"`
- `null`

</p></details>

<details><summary><b>(Inner-level) Additional_arg Object</b></summary><p>

| Keys        | Values
|-------------|----------------------------------------------|
| `"code"`    | *(String)* Code for the additional argument.
| `"default"` | *(Number)* Default value of the additional argument.
| `"desc"`    | *(String)* One-line description about the additional argument.

</p></details>

## JSON Examples

These are some good examples to start with, if you are completely new.

| [`gng_m1.json`](./gng_m1.json) | [`choiceRT_ddm_single.json`](./choiceRT_ddm_single.json) | [`prl_fictitious_multipleB.json`](./prl_fictitious_multipleB.json) | [`ts_par4.json`](./ts_par4.json)
|-|-|-|-|
|`task_name`</br>`model_name`</br>`model_type`</br>~~`notes`~~</br>~~`contributors`~~</br>`data_columns`</br>`parameters`</br>`regressors`</br>`postpreds`</br>~~`additional_args`~~ |`task_name`</br>`model_name`</br>`model_type`</br>`notes`</br>~~`contributors`~~</br>`data_columns`</br>`parameters`</br>~~`regressors`~~</br>~~`postpreds`~~</br>`additional_args` |`task_name`</br>`model_name`</br>`model_type`</br>~~`notes`~~</br>`contributors`</br>`data_columns`</br>`parameters`</br>`regressors`</br>`postpreds`</br>~~`additional_args`~~ |`task_name`</br>`model_name`</br>`model_type`</br>~~`notes`~~</br>`contributors`</br>`data_columns`</br>`parameters`</br>~~`regressors`~~</br>`postpreds`</br>`additional_args`

## JSON Validation

Validating against the current Schema file is a good basis to see if you've written the model JSON file correctly.  
To validate JSON files, you need to have [`jsonschema`][jsonschema] installed; you can install it with `pip install jsonschema`.

[jsonschema]: https://github.com/Julian/jsonschema

To validate a single JSON file (e.g. `gng_m1.json`):
```
$ jsonschema -i gng_m1.json ModelInformation.schema.json
```

To validate all JSON files in directory, use following shell script:
```
$ ./ValidateAll.sh
```

## Automated Python Code Generation

Once you've (correctly) written the JSON file for a new model,
it's possible to automatically generate the corresponding python code for the new model,
using the python script `WritePython.py`:

```
$ ./WritePython.py -h
usage: WritePython.py [-h] [-a] [-v] json_file

positional arguments:
  json_file      JSON file of the model to generate corresponding python code

optional arguments:
  -h, --help     show this help message and exit
  -a, --all      write for all json files in directory
  -v, --verbose  print output to stdout instead of writing to file
```

E.g. (to generate `_gng_m1.py` from `gng_m1.json`):
```
$ ./WritePython.py gng_m1.json
Created file: _gng_m1.py
```

To generate python codes for all json files in directory:
```
$ ./WritePython.py --all .
Created file: _bandit2arm_delta.py
...
Created file: _wcs_sql.py
```
