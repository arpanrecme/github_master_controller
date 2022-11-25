locals {
  PYTHON_REQUIRED_STATUS_CHECKS_CONTEXTS           = ["pylint", "docker"]
  ANSIBLE_ROLE_REQUIRED_STATUS_CHECKS_CONTEXTS     = ["molecule_test"]
  ANSIBLE_PLAYBOOK_REQUIRED_STATUS_CHECKS_CONTEXTS = ["ansible_lint"]
  TERRAFORM_REQUIRED_STATUS_CHECKS_CONTEXTS        = ["terraform_lint", "terraform_plan", "terraform_dryrun", "terraform_validate"]
  SHELL_REQUIRED_STATUS_CHECKS_CONTEXTS            = ["shell_check"]
}
