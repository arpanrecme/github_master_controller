variable "license_template" {
  type      = string
  default   = null
  sensitive = false
}

variable "github_repository_name" {
  type      = string
  default   = null
  sensitive = false
}

variable "github_repository_description" {
  type      = string
  default   = null
  sensitive = false
}

variable "project_topics" {
  type      = list(string)
  default   = null
  sensitive = false
}

variable "repository_default_branch" {
  type        = string
  default     = null
  description = "This is the default branch for the repository at the time of creation."
  sensitive   = false
}

variable "project_topic_controlled_by_master" {
  type      = string
  default   = null
  sensitive = false
}

variable "gitignore_template" {
  type      = string
  default   = null
  sensitive = false
}

variable "protection_contexts" {
  type      = list(string)
  default   = null
  sensitive = false
}
