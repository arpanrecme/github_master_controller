module "ansible_plays" {
  source = "./project_template"

  license_template                   = var.license_template
  repository_default_branch          = var.repository_default_branch
  project_topic_controlled_by_master = var.project_topic_controlled_by_master
  github_repository_name             = "ansible_plays"
  project_topics                     = ["ansible", "playbook"]
  gitignore_template                 = "Python"
  github_repository_description      = "Ansible Plays"
}
