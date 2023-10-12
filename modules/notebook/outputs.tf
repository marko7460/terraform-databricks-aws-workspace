output "notebook" {
  description = "The notebook object"
  value       = databricks_notebook.notebook
}

output "notebook_url" {
  description = "The notebook URL"
  value       = databricks_notebook.notebook.url
}