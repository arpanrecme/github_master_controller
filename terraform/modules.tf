module "arpanrec" {
  source = "./arpanrec"

  license_template                   = var.license_template
  repository_default_branch          = var.repository_default_branch
  project_topic_controlled_by_master = var.project_topic_controlled_by_master

  providers = {
    github = github.arpanrec
  }
}
