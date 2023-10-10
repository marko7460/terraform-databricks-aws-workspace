// Terraform Documentation: https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/mws_workspaces


// Wait on Credential Due to Race Condition
// https://kb.databricks.com/en_US/terraform/failed-credential-validation-checks-error-with-terraform
resource "null_resource" "previous" {}

resource "time_sleep" "wait_30_seconds" {
  depends_on = [null_resource.previous]

  create_duration = "30s"
}

// Credential Configuration
resource "databricks_mws_credentials" "this" {
  provider         = databricks.mws
  account_id       = var.databricks_account_id
  role_arn         = aws_iam_role.cross_account_role.arn
  credentials_name = "${var.workspace_name}-credentials"
  depends_on       = [time_sleep.wait_30_seconds]
}

// Storage Configuration
resource "databricks_mws_storage_configurations" "this" {
  provider                   = databricks.mws
  account_id                 = var.databricks_account_id
  bucket_name                = aws_s3_bucket.root_storage_bucket.id
  storage_configuration_name = "${var.workspace_name}-storage"
}

// Backend REST VPC Endpoint Configuration
resource "databricks_mws_vpc_endpoint" "backend_rest" {
  provider            = databricks.mws
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.backend_rest.id
  vpc_endpoint_name   = "${var.workspace_name}-vpce-backend-${module.vpc.vpc_id}"
  region              = var.region
}

// Backend Rest VPC Endpoint Configuration
resource "databricks_mws_vpc_endpoint" "backend_relay" {
  provider            = databricks.mws
  account_id          = var.databricks_account_id
  aws_vpc_endpoint_id = aws_vpc_endpoint.backend_relay.id
  vpc_endpoint_name   = "${var.workspace_name}-vpce-relay-${module.vpc.vpc_id}"
  region              = var.region
}

// Network Configuration
resource "databricks_mws_networks" "this" {
  provider           = databricks.mws
  account_id         = var.databricks_account_id
  network_name       = "${var.workspace_name}-network"
  security_group_ids = [aws_security_group.sg.id]
  subnet_ids         = module.vpc.private_subnets
  vpc_id             = module.vpc.vpc_id
  vpc_endpoints {
    dataplane_relay = [databricks_mws_vpc_endpoint.backend_relay.vpc_endpoint_id]
    rest_api        = [databricks_mws_vpc_endpoint.backend_rest.vpc_endpoint_id]
  }
}

// Managed Key Configuration
resource "databricks_mws_customer_managed_keys" "managed_storage" {
  provider   = databricks.mws
  account_id = var.databricks_account_id
  aws_key_info {
    key_arn   = aws_kms_key.managed_storage.arn
    key_alias = aws_kms_alias.managed_storage_key_alias.name
  }
  use_cases = ["MANAGED_SERVICES"]
}

// Workspace Storage Key Configuration
resource "databricks_mws_customer_managed_keys" "workspace_storage" {
  provider   = databricks.mws
  account_id = var.databricks_account_id
  aws_key_info {
    key_arn = aws_kms_key.workspace_storage.arn
    //key_alias = "alias/xoogify-test-workspace-workspace-storage-key-alias"
    key_alias = aws_kms_alias.workspace_storage_key_alias.name
  }
  use_cases = ["STORAGE"]
}

// Private Access Setting Configuration
resource "databricks_mws_private_access_settings" "pas" {
  provider                     = databricks.mws
  account_id                   = var.databricks_account_id
  private_access_settings_name = "${var.workspace_name}-PAS"
  region                       = var.region
  public_access_enabled        = true
  private_access_level         = "ACCOUNT"
}

// Workspace Configuration
resource "databricks_mws_workspaces" "this" {
  provider                                 = databricks.mws
  account_id                               = var.databricks_account_id
  aws_region                               = var.region
  workspace_name                           = var.workspace_name
  credentials_id                           = databricks_mws_credentials.this.credentials_id
  storage_configuration_id                 = databricks_mws_storage_configurations.this.storage_configuration_id
  network_id                               = databricks_mws_networks.this.network_id
  private_access_settings_id               = databricks_mws_private_access_settings.pas.private_access_settings_id
  managed_services_customer_managed_key_id = databricks_mws_customer_managed_keys.managed_storage.customer_managed_key_id
  storage_customer_managed_key_id          = databricks_mws_customer_managed_keys.workspace_storage.customer_managed_key_id
  pricing_tier                             = "ENTERPRISE"
  depends_on                               = [databricks_mws_networks.this]
}

// Metastore Assignment
resource "databricks_metastore_assignment" "default_metastore" {
  workspace_id         = databricks_mws_workspaces.this.workspace_id
  metastore_id         = var.metastore_id
  default_catalog_name = var.default_catalog_name
}