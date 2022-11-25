resource "github_repository" "ansible_role_setup_hashicorp_vault" {
  name               = "ansible_role_setup_hashicorp_vault"
  description        = "Install Hashicorp Vault"
  visibility         = "public"
  license_template   = var.license_template
  auto_init          = true
  gitignore_template = "Python"
  topics             = [var.project_topic_controlled_by_master, "ansible", "role", "galaxy"]
}

resource "github_branch_default" "ansible_role_setup_hashicorp_vault" {
  repository = github_repository.ansible_role_setup_hashicorp_vault.name
  branch     = var.repository_default_branch_01292022_main
}

resource "github_branch" "ansible_role_setup_hashicorp_vault_branch_feature_docker" {
  repository = github_repository.ansible_role_setup_hashicorp_vault.name
  branch     = "feature/docker"
}

resource "github_branch" "ansible_role_setup_hashicorp_vault_branch_feature_inprogress" {
  repository = github_repository.ansible_role_setup_hashicorp_vault.name
  branch     = "feature/inprogress"
}

resource "github_branch_protection" "ansible_role_setup_hashicorp_vault" {
  repository_id                   = github_repository.ansible_role_setup_hashicorp_vault.node_id
  pattern                         = "main"
  enforce_admins                  = true
  allows_deletions                = true
  require_signed_commits          = true
  require_conversation_resolution = true
  required_status_checks {
    strict   = true
    contexts = local.ANSIBLE_ROLE_REQUIRED_STATUS_CHECKS_CONTEXTS
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    required_approving_review_count = 0
  }
}
