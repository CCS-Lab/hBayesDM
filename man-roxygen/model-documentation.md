# How to document model functions (by Jethro Lee)

Template Variable | Required? | Format
-|-|-
`MODEL_FUNCTION` | Y |
`CONTRIBUTOR` | *optional* | \href{ &nbsp; }{ &nbsp; }, ...
`TASK_NAME` | Y |
`TASK_CITE` | *optional* | ( &nbsp; )
`MODEL_NAME` | Y |
`MODEL_CITE` | *optional* | ( &nbsp; )
`MODEL_TYPE` | Y | `Hierarchical`<br/>*or*<br/>`Individual`<br/>*or*<br/>`Multiple-Block Hierarchical`
`DATA_COLUMNS` | Y | " &nbsp; ", ...
`PARAMETERS` | Y | " &nbsp; " ( &nbsp; ), ...
`REGRESSORS` | *optional* | " &nbsp; ", ...
`IS_NULL_POSTPREDS` | *optional* | `TRUE`
`LENGTH_DATA_COLUMNS` | Y | #
`DETAILS_DATA_1` | Y | `\item{"subjID"}{A unique identifier for each subject in the data-set.}`
`DETAILS_DATA_2` | *optional* | \item{" &nbsp; "}{ &nbsp; }
`DETAILS_DATA_3` | *optional* | \item{" &nbsp; "}{ &nbsp; }
`DETAILS_DATA_4` | *optional* | \item{" &nbsp; "}{ &nbsp; }
`DETAILS_DATA_5` | *optional* | \item{" &nbsp; "}{ &nbsp; }
`DETAILS_DATA_6` | *optional* | \item{" &nbsp; "}{ &nbsp; }
`DETAILS_DATA_7` | *optional* | \item{" &nbsp; "}{ &nbsp; }
`DETAILS_DATA_8` | *optional* | \item{" &nbsp; "}{ &nbsp; }
`DETAILS_DATA_9` | *optional* | \item{" &nbsp; "}{ &nbsp; }

## Example: `igt_pvl_decay.R`
```R
#' @templateVar MODEL_FUNCTION igt_pvl_decay
#' @templateVar TASK_NAME Iowa Gambling Task
#' @templateVar MODEL_NAME Prospect Valence Learning (PVL) Decay-RI
#' @templateVar MODEL_CITE (Ahn et al., 2014, Frontiers in Psychology)
#' @templateVar MODEL_TYPE Hierarchical
#' @templateVar DATA_COLUMNS "subjID", "choice", "gain", "loss"
#' @templateVar PARAMETERS "A" (decay rate), "alpha" (outcome sensitivity), "cons" (response consistency), "lambda" (loss aversion)
#' @templateVar LENGTH_DATA_COLUMNS 4
#' @templateVar DETAILS_DATA_1 \item{"subjID"}{A unique identifier for each subject in the data-set.}
#' @templateVar DETAILS_DATA_2 \item{"choice"}{A nominal integer indicating which deck was chosen on that trial (where A==1, B==2, C==3, and D==4).}
#' @templateVar DETAILS_DATA_3 \item{"gain"}{A floating point number representing the amount of currency won on the given trial (e.g. 50, 100).}
#' @templateVar DETAILS_DATA_4 \item{"loss"}{A floating point number representing the amount of currency lost on the given trial (e.g. 0, -50).}
#'
#' @template model-documentation
#'
#' @export
#' @include hBayesDM_model.R
#'
#' @param payscale \strong{(Model-specific argument.)} Raw payoffs within data are divided by this number. Used for scaling data. Defaults to 100.
#'
#' @references
#' Ahn, W.-Y., Vasilev, G., Lee, S.-H., Busemeyer, J. R., Kruschke, J. K., Bechara, A., & Vassileva, J. (2014). Decision-making in stimulant and opiate addicts in protracted abstinence: evidence from computational modeling with pure users. Frontiers in Psychology, 5, 1376. http://doi.org/10.3389/fpsyg.2014.00849
```

## How to work with the template (`model-documentation.R`)
- R expressions between `<%` and `%>` are **executed** in-place.
- The value of the R expression between `<%=` and `%>` is **printed**.
- All text outside of that is printed *as-is*.
#### See more: roxygen2 uses [brew](https://www.rdocumentation.org/packages/brew/versions/1.0-6/topics/brew) to preprocess the template.
