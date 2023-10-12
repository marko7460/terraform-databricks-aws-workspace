output "cluster_id" {
  description = "Cluster ID"
  value       = databricks_cluster.this.id
}

output "cluster_name" {
  description = "Cluster Name"
  value       = databricks_cluster.this.cluster_name
}

output "cluster" {
  description = "Cluster"
  value       = databricks_cluster.this
}

output "cluster_policy" {
  description = "Cluster Policy"
  value       = databricks_cluster_policy.this
}