variable "license_template" {
  type    = string
  default = null
}

variable "repository_default_branch_01292022_main" {
  type        = string
  default     = null
  description = "This is the default branch for the repository at the time of creation."
}

variable "project_topic_controlled_by_master" {
  type      = string
  default   = null
  sensitive = false
}

variable "GLOBAL_CONFIG_ENDPOINT" {
  type      = string
  default   = null
  sensitive = false
}
