resource "github_repository" "repo_ansible_collection_utilities" {
  name               = "repo_ansible_collection_utilities"
  description        = "Ansible Collection"
  visibility         = "public"
  license_template   = var.license_template
  auto_init          = true
  gitignore_template = "Python"
  topics             = [var.project_topic_controlled_by_master, "ansible", "role", "galaxy"]
}

resource "github_branch_default" "repo_ansible_collection_utilities" {
  repository = github_repository.repo_ansible_collection_utilities.name
  branch     = var.repository_default_branch_01292022_main
}

resource "github_branch" "repo_ansible_collection_utilities_branch_feature_inprogress" {
  repository = github_repository.repo_ansible_collection_utilities.name
  branch     = "feature/inprogress"
}

resource "github_branch_protection" "repo_ansible_collection_utilities" {
  repository_id                   = github_repository.repo_ansible_collection_utilities.node_id
  pattern                         = "main"
  enforce_admins                  = true
  allows_deletions                = true
  require_signed_commits          = true
  require_conversation_resolution = true
  required_status_checks {
    strict   = true
    contexts = local.ANSIBLE_REQUIRED_STATUS_CHECKS_CONTEXTS
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    required_approving_review_count = 0
  }
}