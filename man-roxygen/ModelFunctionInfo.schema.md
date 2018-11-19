### Information currently kept track of by JSON Schema:
Property | Required | Explanation
-|-|-
"model_function" | o | Name of the model function.
"data_columns" | o | Necessary data columns for the user data.
"data_list" | o | List of preprocessed user data that gets passed to Stan.
"parameters" | o | Parameters of this model.
"gen_init" | o | Initial value & bounds of the parameters **used in the R file**.</br>*\* Note that these bounds are just for setting the initial values; these bounds may differ from the boundary constraints given to the parameters in the Stan file.*
"regressors" | x | Regressors of this model.

#### Written by Jethro Lee.
