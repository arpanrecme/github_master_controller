resource "github_repository" "github_repository_resource" {
  name             = var.github_repository_name
  license_template = var.license_template
  # topics             = [var.project_topic_controlled_by_master, "python", "vault", "bitwarden"]
  topics             = concat(var.project_topics, [var.project_topic_controlled_by_master])
  gitignore_template = var.gitignore_template
  description        = var.github_repository_description
}

resource "github_branch_default" "github_branch_default_main" {
  repository = github_repository.github_repository_resource.name
  branch     = var.repository_default_branch
}

resource "github_branch" "branch_feature_inprogress" {
  repository = github_repository.github_repository_resource.name
  branch     = "feature/inprogress"
}

resource "github_branch_protection" "github_branch_protection_main" {
  repository_id                   = github_repository.github_repository_resource.node_id
  pattern                         = "main"
  enforce_admins                  = true
  allows_deletions                = false
  require_signed_commits          = true
  require_conversation_resolution = true
  required_status_checks {
    strict   = true
    contexts = var.protection_contexts
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    required_approving_review_count = 0
  }
}

resource "github_branch_protection" "github_branch_protection_backup" {
  repository_id       = github_repository.github_repository_resource.node_id
  pattern             = "backup/**"
  allows_deletions    = false
  allows_force_pushes = false
  lock_branch         = true
}
