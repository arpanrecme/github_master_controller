resource "github_repository" "ansible_plays" {
  name               = "ansible_plays"
  description        = "Install Hashicorp Vault"
  visibility         = "public"
  license_template   = var.license_template
  auto_init          = true
  gitignore_template = "Python"
  topics             = [var.project_topic_controlled_by_master, "ansible", "playbook"]
}

resource "github_branch_default" "ansible_plays" {
  repository = github_repository.ansible_plays.name
  branch     = var.repository_default_branch_01292022_main
}

resource "github_branch" "ansible_plays_branch_feature_inprogress" {
  repository = github_repository.ansible_plays.name
  branch     = "feature/inprogress"
}

resource "github_branch_protection" "ansible_plays_main" {
  repository_id                   = github_repository.ansible_plays.node_id
  pattern                         = "main"
  enforce_admins                  = true
  allows_deletions                = false
  require_signed_commits          = true
  require_conversation_resolution = true
  required_status_checks {
    strict = true
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    required_approving_review_count = 0
  }
}

resource "github_branch_protection" "ansible_plays_backup" {
  repository_id       = github_repository.ansible_plays.node_id
  pattern             = "backup/**"
  allows_deletions    = false
  allows_force_pushes = false
  lock_branch         = true
}