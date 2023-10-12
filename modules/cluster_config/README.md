# Cluster Config
This module is used to create a cluster config for DataBricks.

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
| autoscale\_max\_workers | The minimum number of workers to autoscale to | `number` | `8` | no |
| autoscale\_min\_workers | The minimum number of workers to autoscale to | `number` | `1` | no |
| cluster\_name | The name of the cluster | `string` | n/a | yes |
| cluster\_policy | The cluster policy json | `string` | `"{\n    \"autotermination_minutes\" : {\n      \"type\" : \"fixed\",\n      \"value\" : 15,\n      \"hidden\" : true\n    }\n}\n"` | no |
| data\_security\_mode | The data security mode. Can be SINGLE\_USER or USER\_ISOLATION. Default to NONE. | `string` | `"NONE"` | no |
| gb\_per\_core | The number of GB per core to request | `number` | `1` | no |
| local\_disk | Whether to use local disk | `bool` | `true` | no |
| local\_disk\_min\_size | The minimum size of the local disk to request | `number` | `0` | no |
| max\_clusters\_per\_user | The maximum number of clusters per user | `number` | `1` | no |
| min\_cores | The minimum number of cores to request | `number` | `4` | no |
| min\_gpus | The minimum number of GPUs to request | `number` | `0` | no |
| min\_memory\_gb | The minimum amount of memory to request | `number` | `0` | no |
| single\_user\_name | Username (email) of the user that can use the cluster if data\_security\_mode is SINGLE\_USER | `string` | n/a | yes |
| spark\_conf | Spark configuration | `map(string)` | `{}` | no |
| spark\_env\_vars | Spark environment variables | `map(string)` | `{}` | no |
| spark\_latest | Whether to use the latest version of Spark | `bool` | `false` | no |
| spark\_long\_term\_support | Whether to use Spark long term support | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| cluster | Cluster |
| cluster\_id | Cluster ID |
| cluster\_name | Cluster Name |
| cluster\_policy | Cluster Policy |