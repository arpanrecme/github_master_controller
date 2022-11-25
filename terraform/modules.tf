module "arpanrec" {
  source = "./arpanrec"

  license_template                        = var.license_template
  repository_default_branch_01292022_main = var.repository_default_branch_01292022_main
  project_topic_controlled_by_master      = var.project_topic_controlled_by_master
  GLOBAL_CONFIG_ENDPOINT                  = var.GLOBAL_CONFIG_ENDPOINT
}
