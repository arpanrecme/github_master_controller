module "util_scripts" {
  source = "./project_template"

  license_template                   = var.license_template
  repository_default_branch          = var.repository_default_branch
  project_topic_controlled_by_master = var.project_topic_controlled_by_master
  github_repository_name             = "util_scripts"
  project_topics                     = ["bash"]
  gitignore_template                 = "Python"
  github_repository_description      = "Day to Day Utility Scripts"
}
