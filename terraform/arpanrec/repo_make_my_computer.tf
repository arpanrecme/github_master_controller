module "make_my_computer" {
  source = "./project_template"

  license_template                   = var.license_template
  repository_default_branch          = var.repository_default_branch
  project_topic_controlled_by_master = var.project_topic_controlled_by_master
  github_repository_name             = "make_my_computer"
  project_topics                     = ["linux", "shell", "bootstrap"]
  gitignore_template                 = "Python"
  github_repository_description      = "OS Bootstrap script"
  protection_contexts                = local.SHELL_REQUIRED_STATUS_CHECKS_CONTEXTS
}
