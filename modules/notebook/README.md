# Example Notebook
This module is used to create an example notebook in Databricks workspace.

To use this module you have to define the following environment variables:
- `DATABRICKS_HOST`: Workspace URL.
- `DATABRICKS_CLIENT_ID`: The databricks client ID of the service principle. See [here](https://docs.databricks.com/en/dev-tools/authentication-oauth.html) for more information.
- `DATABRICKS_CLIENT_SECRET`: The databricks client ID secret of the service principle. See [here](https://docs.databricks.com/en/dev-tools/authentication-oauth.html) for more information.

## Providers

| Name | Version |
|------|---------|
| databricks | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| content | The content of the notebook | `string` | `"display(spark.range(10))"` | no |
| language | One of SCALA, PYTHON, SQL, R | `string` | `"PYTHON"` | no |
| path | The absolute path of the notebook or directory, beginning with '/, e.g. '/Shared'. | `string` | `"/Shared/Demo"` | no |

## Outputs

| Name | Description |
|------|-------------|
| notebook | The notebook object |
| notebook\_url | The notebook URL |