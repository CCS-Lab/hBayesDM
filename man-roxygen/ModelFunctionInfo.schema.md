### Information currently kept track of by JSON Schema:
Property | Explanation
-|-
"model_function" | Name of the model function.
"data_columns" | Necessary data columns for the user data.
"data_list" | List of preprocessed user data that gets passed to Stan.
"parameters" | Parameters of this model.
"init" | Initial value & bounds of the parameters **used in the R file**.</br>*Note that these bounds are just for setting the initial values; these bounds may differ from the boundary constraints given to the parameters in the Stan file.*
"regressors" | Regressors of this model.

#### Written by Jethro Lee.
