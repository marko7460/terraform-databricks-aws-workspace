variable "workspace_name" {
  type        = string
  description = "Databricks Workspace Name"
}

variable "databricks_account_id" {
  type        = string
  description = "Databricks Account ID"
}

variable "aws_account_id" {
  type        = string
  description = "AWS Account ID"
}

variable "region" {
  description = "AWS Region"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "metastore_id" {
  type        = string
  description = "Databricks Metastore ID"
}

variable "bucket" {
  description = "Root Bucket Name"
  type        = string
}

variable "harden_firewall" {
  type        = bool
  description = "Enable Firewall and Harden Network Security"
  default     = false
}

variable "default_catalog_name" {
  type        = string
  description = "Default Unity Catalog Name for Databricks Metastore"
  default     = "hive_metastore"
}

#variable "enable_restrictive_root_bucket_boolean" {
#  type      = bool
#  sensitive = true
#}


variable "vpc_cidr_range" {
  description = "VPC CIDR Range"
  type        = string
  default     = "10.0.0.0/18"
}

variable "private_subnets_cidr" {
  description = "Private Subnets CIDR Ranges"
  type        = list(string)
  default     = ["10.0.16.0/22", "10.0.24.0/22"]
}

variable "privatelink_subnets_cidr" {
  description = "Private Link Subnets CIDR Ranges"
  type        = list(string)
  default     = ["10.0.32.0/26", "10.0.32.64/26"]
}

variable "public_subnets_cidr" {
  description = "Public Subnets CIDR Ranges"
  type        = list(string)
  default     = ["10.0.32.128/26", "10.0.32.192/26"]
}

variable "firewall_subnets_cidr" {
  description = "Firewall Subnets CIDR Ranges"
  type        = list(string)
  default     = ["10.0.33.0/26", "10.0.33.64/26"]
}

variable "firewall_allow_list" {
  description = "Firewall Allow List"
  type        = list(string)
  default     = [".pypi.org", ".pythonhosted.org", ".cran.r-project.org", "mdb7sywh50xhpr.chkweekm4xjq.us-east-1.rds.amazonaws.com"]
}

variable "firewall_protocol_deny_list" {
  description = "Firewall Protocol Deny List"
  type        = string
  default     = "ICMP,FTP,SSH"
}

variable "sg_egress_ports" {
  description = "Security Group Egress Ports"
  type        = list(string)
  default     = [443, 3306, 6666]
}

variable "sg_ingress_protocol" {
  description = "Security Group Ingress Protocol"
  type        = list(string)
  default     = ["tcp", "udp"]
}

variable "sg_egress_protocol" {
  description = "Security Group Egress Protocol"
  type        = list(string)
  default     = ["tcp", "udp"]
}

variable "workspace_vpce_service" {
  description = "Workspace VPCE Service"
  type        = string
  default     = "com.amazonaws.vpce.us-east-1.vpce-svc-09143d1e626de2f04"
}

variable "relay_vpce_service" {
  description = "Relay VPCE Service"
  type        = string
  default     = "com.amazonaws.vpce.us-east-1.vpce-svc-00018a8c3ff62ffdf"
}

variable "tags" {
  description = "Tags to apply to the resources created"
  type        = map(string)
  default     = {}
}

