module "bitwarden_export_migrate" {
  source = "./project_template"

  license_template                   = var.license_template
  repository_default_branch          = var.repository_default_branch
  project_topic_controlled_by_master = var.project_topic_controlled_by_master
  github_repository_name             = "bitwarden_export_migrate"
  project_topics                     = ["bitwarden", "vault", "python"]
  gitignore_template                 = "Python"
  github_repository_description      = "Bitwarden Export"
}
