variable "cluster_name" {
  description = "The name of the cluster"
  type        = string
}

variable "data_security_mode" {
  description = "The data security mode. Can be SINGLE_USER or USER_ISOLATION. Default to NONE."
  type        = string
  default     = "NONE"
}

variable "single_user_name" {
  description = "Username (email) of the user that can use the cluster if data_security_mode is SINGLE_USER"
  type        = string
  default     = null
}

variable "local_disk" {
  description = "Whether to use local disk"
  type        = bool
  default     = true
}

variable "min_cores" {
  description = "The minimum number of cores to request"
  type        = number
  default     = 4
}

variable "gb_per_core" {
  description = "The number of GB per core to request"
  type        = number
  default     = 1
}

variable "min_gpus" {
  description = "The minimum number of GPUs to request"
  type        = number
  default     = 0
}

variable "min_memory_gb" {
  description = "The minimum amount of memory to request"
  type        = number
  default     = 0
}

variable "local_disk_min_size" {
  description = "The minimum size of the local disk to request"
  type        = number
  default     = 0
}

variable "autoscale_min_workers" {
  description = "The minimum number of workers to autoscale to"
  type        = number
  default     = 1
}

variable "autoscale_max_workers" {
  description = "The minimum number of workers to autoscale to"
  type        = number
  default     = 8
}

variable "spark_long_term_support" {
  description = "Whether to use Spark long term support"
  type        = bool
  default     = true
}

variable "spark_latest" {
  description = "Whether to use the latest version of Spark"
  type        = bool
  default     = false
}

variable "spark_conf" {
  description = "Spark configuration"
  type        = map(string)
  default     = {}
}

variable "spark_env_vars" {
  description = "Spark environment variables"
  type        = map(string)
  default     = {}
}

variable "max_clusters_per_user" {
  description = "The maximum number of clusters per user"
  type        = number
  default     = 1
}

variable "cluster_policy" {
  description = "The cluster policy json"
  type        = string
  default     = <<EOF
{
    "autotermination_minutes" : {
      "type" : "fixed",
      "value" : 15,
      "hidden" : true
    }
}
EOF
}