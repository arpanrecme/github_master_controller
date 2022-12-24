variable "license_template" {
  type    = string
  default = "mit"
}

variable "repository_default_branch" {
  type        = string
  default     = "main"
  description = "This is the default branch for the repository at the time of creation."
}

variable "project_topic_controlled_by_master" {
  type      = string
  default   = "controlled-by-gh-repo-manage"
  sensitive = false
}

variable "GLOBAL_CONFIG_ENDPOINT" {
  type      = string
  default   = "https://raw.githubusercontent.com/arpanrecme/dotfiles/main/.config/global.json"
  sensitive = false
}
