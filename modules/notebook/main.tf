resource "databricks_notebook" "notebook" {
  content_base64 = base64encode(var.content)
  path           = var.path
  language       = var.language
}