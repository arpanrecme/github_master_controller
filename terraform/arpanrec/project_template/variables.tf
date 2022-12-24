variable "license_template" {
  type      = string
  default   = null
  sensitive = false
  validation {
    condition     = length(var.license_template) > 1
    error_message = "Missing Github license template"
  }
}

variable "github_repository_name" {
  type      = string
  default   = null
  sensitive = false
  validation {
    condition     = length(var.github_repository_name) > 1
    error_message = "Missing Github Repository name"
  }
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
  validation {
    condition     = length(var.project_topics) > 1
    error_message = "Missing Github Repository Topics"
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

variable "gitignore_template" {
  type      = string
  default   = null
  sensitive = false
  validation {
    condition     = length(var.gitignore_template) > 1
    error_message = "Missing Github Ignore Template Name"
  }
}

variable "protection_contexts" {
  type      = list(string)
  default   = null
  sensitive = false
  validation {
    condition     = length(var.protection_contexts) > 0
    error_message = "Missing mandatory pipeline checks"
  }
}
