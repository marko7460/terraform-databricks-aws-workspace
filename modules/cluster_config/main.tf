// Terraform Documentation: https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster

// Cluster Version
data "databricks_spark_version" "latest_lts" {
  long_term_support = !var.spark_long_term_support ? null : var.spark_long_term_support
  latest            = !var.spark_latest ? null : var.spark_latest
}

data "databricks_node_type" "this" {
  local_disk          = var.local_disk
  min_cores           = var.min_cores
  gb_per_core         = var.gb_per_core
  min_gpus            = var.min_gpus
  min_memory_gb       = var.min_memory_gb
  local_disk_min_size = var.local_disk_min_size
}

resource "databricks_cluster_policy" "this" {
  name                  = "${var.cluster_name}-cluster-policy"
  definition            = jsonencode(jsondecode(var.cluster_policy))
  max_clusters_per_user = var.max_clusters_per_user
}

// Cluster Creation
resource "databricks_cluster" "this" {
  cluster_name  = var.cluster_name
  spark_version = data.databricks_spark_version.latest_lts.id
  node_type_id  = data.databricks_node_type.this.id
  policy_id     = databricks_cluster_policy.this.id
  autoscale {
    min_workers = var.autoscale_min_workers
    max_workers = var.autoscale_max_workers
  }
  spark_conf         = var.spark_conf
  spark_env_vars     = var.spark_env_vars
  data_security_mode = var.data_security_mode
  single_user_name   = var.single_user_name
  depends_on = [
    databricks_cluster_policy.this
  ]
  autotermination_minutes = 15
}

resource "databricks_permissions" "restart" {
  count      = var.single_user_name != null ? 1 : 0
  cluster_id = databricks_cluster.this.id
  access_control {
    user_name        = var.single_user_name
    permission_level = "CAN_RESTART"
  }
}
