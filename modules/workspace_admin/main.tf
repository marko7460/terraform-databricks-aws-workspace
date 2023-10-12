resource "databricks_workspace_conf" "this" {
  custom_config = {
    enableResultsDownloading        = var.enableResultsDownloading
    enableNotebookTableClipboard    = var.enableNotebookTableClipboard
    enableVerboseAuditLogs          = var.enableVerboseAuditLogs
    "enable-X-Frame-Options"        = var.enable_X_Frame_Options
    "enable-X-Content-Type-Options" = var.enable_X_Content_Type_Options
    "enable-X-XSS-Protection"       = var.enable_X_XSS_Protection
    enableWebTerminal               = var.enableWebTerminal
    enableDbfsFileBrowser           = var.enableDbfsFileBrowser
    enforceUserIsolation            = var.enforceUserIsolation
    enableNotebookGitVersioning     = var.enableNotebookGitVersioning
    enableIpAccessLists             = length(var.ip_addresses) > 0 ? true : false
  }
}

resource "databricks_ip_access_list" "allowed_list" {
  count        = length(var.ip_addresses) > 0 ? 1 : 0
  label        = "allow_in"
  list_type    = "ALLOW"
  ip_addresses = var.ip_addresses
  depends_on   = [databricks_workspace_conf.this]
}