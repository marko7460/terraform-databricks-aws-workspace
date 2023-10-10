output "workspace_url" {
  description = "The URL of the workspace"
  value       = databricks_mws_workspaces.this.workspace_url
}

output "workspace_id" {
  description = "The ID of the workspace"
  value       = databricks_mws_workspaces.this.id
}

output "workspace" {
  description = "The workspace object"
  value       = databricks_mws_workspaces.this
  sensitive   = true
}