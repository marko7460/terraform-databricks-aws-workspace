variable "path" {
  description = "The absolute path of the notebook or directory, beginning with '/, e.g. '/Shared'."
  type        = string
  default     = "/Shared/Demo"
}

variable "content" {
  description = "The content of the notebook"
  type        = string
  default     = "display(spark.range(10))"
}

variable "language" {
  description = "One of SCALA, PYTHON, SQL, R"
  type        = string
  default     = "PYTHON"
}