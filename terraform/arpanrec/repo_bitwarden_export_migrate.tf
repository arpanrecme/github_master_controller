resource "github_repository" "bitwarden_export_migrate" {
  name             = "bitwarden_export_migrate"
  license_template = var.license_template
  topics           = [var.project_topic_controlled_by_master, "python", "vault", "bitwarden"]
}

resource "github_branch_default" "bitwarden_export_migrate" {
  repository = github_repository.bitwarden_export_migrate.name
  branch     = var.repository_default_branch_01292022_main
}

resource "github_branch" "bitwarden_export_migrate_keepass_export" {
  repository    = github_repository.bitwarden_export_migrate.name
  branch        = "keepass_export"
  source_branch = var.repository_default_branch_01292022_main
}

resource "github_branch" "bitwarden_export_migrate_login_using_code" {
  repository    = github_repository.bitwarden_export_migrate.name
  branch        = "login_using_code"
  source_branch = var.repository_default_branch_01292022_main
}

resource "github_branch" "bitwarden_export_migrate_oldcode" {
  repository    = github_repository.bitwarden_export_migrate.name
  branch        = "oldcode"
  source_branch = var.repository_default_branch_01292022_main
}

resource "github_branch" "bitwarden_export_migrate_branch_feature_inprogress" {
  repository = github_repository.bitwarden_export_migrate.name
  branch     = "feature/inprogress"
}

resource "github_branch_protection" "bitwarden_export_migrate" {
  repository_id                   = github_repository.bitwarden_export_migrate.node_id
  pattern                         = "main"
  enforce_admins                  = true
  allows_deletions                = true
  require_signed_commits          = true
  require_conversation_resolution = true
  required_status_checks {
    strict   = true
    contexts = local.PYTHON_REQUIRED_STATUS_CHECKS_CONTEXTS
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    required_approving_review_count = 0
  }
}
