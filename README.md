# terraform-databricks-aws-workspace
Databricks terraform module for AWS workspace. This module creates a Databricks workspace and configures the workspace 
to use the AWS S3 bucket as the default storage location.

## Providers

| Name | Version |
|------|---------|
| aws | n/a |
| databricks | n/a |
| databricks.mws | n/a |
| null | n/a |
| time | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| availability\_zones | Availability Zones | `list(string)` | n/a | yes |
| aws\_account\_id | AWS Account ID | `string` | n/a | yes |
| bucket | Root Bucket Name | `string` | n/a | yes |
| databricks\_account\_id | Databricks Account ID | `string` | n/a | yes |
| default\_catalog\_name | Default Unity Catalog Name for Databricks Metastore | `string` | `"hive_metastore"` | no |
| firewall\_allow\_list | Firewall Allow List | `list(string)` | <pre>[<br>  ".pypi.org",<br>  ".pythonhosted.org",<br>  ".cran.r-project.org",<br>  "mdb7sywh50xhpr.chkweekm4xjq.us-east-1.rds.amazonaws.com"<br>]<br></pre> | no |
| firewall\_protocol\_deny\_list | Firewall Protocol Deny List | `string` | `"ICMP,FTP,SSH"` | no |
| firewall\_subnets\_cidr | Firewall Subnets CIDR Ranges | `list(string)` | <pre>[<br>  "10.0.33.0/26",<br>  "10.0.33.64/26"<br>]<br></pre> | no |
| harden\_firewall | Enable Firewall and Harden Network Security | `bool` | `false` | no |
| metastore\_id | Databricks Metastore ID | `string` | n/a | yes |
| private\_subnets\_cidr | Private Subnets CIDR Ranges | `list(string)` | <pre>[<br>  "10.0.16.0/22",<br>  "10.0.24.0/22"<br>]<br></pre> | no |
| privatelink\_subnets\_cidr | Private Link Subnets CIDR Ranges | `list(string)` | <pre>[<br>  "10.0.32.0/26",<br>  "10.0.32.64/26"<br>]<br></pre> | no |
| public\_subnets\_cidr | Public Subnets CIDR Ranges | `list(string)` | <pre>[<br>  "10.0.32.128/26",<br>  "10.0.32.192/26"<br>]<br></pre> | no |
| region | AWS Region | `string` | n/a | yes |
| relay\_vpce\_service | Relay VPCE Service | `string` | `"com.amazonaws.vpce.us-east-1.vpce-svc-00018a8c3ff62ffdf"` | no |
| sg\_egress\_ports | Security Group Egress Ports | `list(string)` | <pre>[<br>  443,<br>  3306,<br>  6666<br>]<br></pre> | no |
| sg\_egress\_protocol | Security Group Egress Protocol | `list(string)` | <pre>[<br>  "tcp",<br>  "udp"<br>]<br></pre> | no |
| sg\_ingress\_protocol | Security Group Ingress Protocol | `list(string)` | <pre>[<br>  "tcp",<br>  "udp"<br>]<br></pre> | no |
| tags | Tags to apply to the resources created | `map(string)` | `{}` | no |
| vpc\_cidr\_range | VPC CIDR Range | `string` | `"10.0.0.0/18"` | no |
| workspace\_name | Databricks Workspace Name | `string` | n/a | yes |
| workspace\_vpce\_service | Workspace VPCE Service | `string` | `"com.amazonaws.vpce.us-east-1.vpce-svc-09143d1e626de2f04"` | no |

## Outputs

| Name | Description |
|------|-------------|
| workspace | The workspace object |
| workspace\_id | The ID of the workspace |
| workspace\_url | The URL of the workspace |