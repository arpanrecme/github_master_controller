resource "github_repository" "paas_linode" {
  name               = "paas_linode"
  description        = "Linode Cloud management"
  visibility         = "public"
  license_template   = var.license_template
  auto_init          = true
  gitignore_template = "Python"
  topics             = [var.project_topic_controlled_by_master, "linode", "terraform", "paas", "iac"]
}

resource "github_branch_default" "paas_linode" {
  repository = github_repository.paas_linode.name
  branch     = var.repository_default_branch_01292022_main
}

resource "github_branch" "paas_linode_branch_feature_inprogress" {
  repository = github_repository.paas_linode.name
  branch     = "feature/inprogress"
}

resource "github_branch_protection" "paas_linode" {
  repository_id                   = github_repository.paas_linode.node_id
  pattern                         = "main"
  enforce_admins                  = true
  allows_deletions                = true
  require_signed_commits          = true
  require_conversation_resolution = true
  required_status_checks {
    strict   = true
    contexts = local.TERRAFORM_REQUIRED_STATUS_CHECKS_CONTEXTS
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    restrict_dismissals             = false
    required_approving_review_count = 0
  }
}
