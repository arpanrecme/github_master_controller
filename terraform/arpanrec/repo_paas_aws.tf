resource "github_repository" "paas_aws" {
  name               = "paas_aws"
  description        = "AWS Cloud management"
  visibility         = "public"
  license_template   = var.license_template
  auto_init          = true
  gitignore_template = "Python"
  topics             = [var.project_topic_controlled_by_master, "aws", "terraform", "paas", "iac"]
}

resource "github_branch_default" "paas_aws" {
  repository = github_repository.paas_aws.name
  branch     = var.repository_default_branch_01292022_main
}

resource "github_branch" "paas_aws_branch_feature_inprogress" {
  repository = github_repository.paas_aws.name
  branch     = "feature/inprogress"
}

resource "github_branch_protection" "paas_aws" {
  repository_id                   = github_repository.paas_aws.node_id
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
