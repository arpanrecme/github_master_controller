resource "github_repository" "util_scripts" {
  name               = "util_scripts"
  license_template   = var.license_template
  description        = "Day to Day Utility Scripts"
  visibility         = "public"
  gitignore_template = "Python"
  auto_init          = true
  topics             = [var.project_topic_controlled_by_master, "bash"]
}

resource "github_branch_default" "util_scripts" {
  repository = github_repository.util_scripts.name
  branch     = var.repository_default_branch_01292022_main
}

resource "github_branch" "util_scripts_branch_feature_inprogress" {
  repository = github_repository.util_scripts.name
  branch     = "feature/inprogress"
}

resource "github_branch_protection" "util_scripts" {
  repository_id                   = github_repository.util_scripts.node_id
  pattern                         = "main"
  enforce_admins                  = true
  allows_deletions                = true
  require_signed_commits          = true
  require_conversation_resolution = true
  required_status_checks {
    strict   = true
    contexts = local.SHELL_REQUIRED_STATUS_CHECKS_CONTEXTS
  }

  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    required_approving_review_count = 0
  }
}
