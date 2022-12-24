variable "license_template" {
  type      = string
  default   = null
  sensitive = false
  validation {
    condition     = length(var.license_template) > 1
    error_message = "Missing Github license template"
  }
}

variable "repository_default_branch" {
  type        = string
  default     = null
  description = "This is the default branch for the repository at the time of creation."
  sensitive   = false
  validation {
    condition     = length(var.repository_default_branch) > 1
    error_message = "Missing Github Default Branch for the repository"
  }
}

variable "project_topic_controlled_by_master" {
  type      = string
  default   = null
  sensitive = false
  validation {
    condition     = length(var.project_topic_controlled_by_master) > 1
    error_message = "Missing Github Topic name for controlled by terraform"
  }
}
