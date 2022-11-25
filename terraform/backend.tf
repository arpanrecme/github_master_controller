terraform {
  backend "remote" {
    workspaces {
      name = "github_master_controller"
    }
  }
}
