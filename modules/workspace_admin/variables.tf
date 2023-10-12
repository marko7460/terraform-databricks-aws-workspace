variable "enableResultsDownloading" {
  type    = bool
  default = false
}

variable "enableNotebookTableClipboard" {
  type    = bool
  default = false
}

variable "enableVerboseAuditLogs" {
  type    = bool
  default = true
}

variable "enable_X_Frame_Options" {
  type    = bool
  default = true
}

variable "enable_X_Content_Type_Options" {
  type    = bool
  default = true
}

variable "enable_X_XSS_Protection" {
  type    = bool
  default = true
}

variable "enableWebTerminal" {
  type    = bool
  default = true
}

variable "enableDbfsFileBrowser" {
  type    = bool
  default = false
}

variable "enforceUserIsolation" {
  type    = bool
  default = true
}

variable "enableNotebookGitVersioning" {
  type    = bool
  default = false
}

variable "ip_addresses" {
  description = "IP allow list"
  type        = list(string)
  default     = []
}
