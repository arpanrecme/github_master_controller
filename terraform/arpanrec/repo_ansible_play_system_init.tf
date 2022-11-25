resource "github_repository" "ansible_play_system_init" {
  name               = "ansible_play_system_init"
  description        = "Setup New Debian System"
  visibility         = "public"
  license_template   = var.license_template
  auto_init          = true
  gitignore_template = "Python"
  topics             = [var.project_topic_controlled_by_master, "ansible", "playbook"]
}

resource "github_branch_default" "ansible_play_system_init" {
  repository = github_repository.ansible_play_system_init.name
  branch     = var.repository_default_branch_01292022_main
}

resource "github_branch" "ansible_play_system_init_branch_feature_inprogress" {
  repository = github_repository.ansible_play_system_init.name
  branch     = "feature/inprogress"
}

resource "github_branch_protection" "ansible_play_system_init" {
  repository_id                   = github_repository.ansible_play_system_init.node_id
  pattern                         = "main"
  enforce_admins                  = true
  allows_deletions                = true
  require_signed_commits          = true
  require_conversation_resolution = true
  required_status_checks {
    strict   = true
    contexts = local.ANSIBLE_PLAYBOOK_REQUIRED_STATUS_CHECKS_CONTEXTS
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    required_approving_review_count = 0
  }
}
