terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "5.12.0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "3.9.1"
    }
    http = {
      source  = "hashicorp/http"
      version = "3.1.0"
    }
  }
}

provider "vault" {
  address      = local.VAULT_ADDR
  ca_cert_file = var.LOCAL_FILE_ROOT_CA_CERTIFICATE
  auth_login {
    path = "auth/${var.VAULT_APPROLE_AUTH_MOUNT}/login"
    parameters = {
      role_id   = var.VAULT_APPROLE_ID
      secret_id = var.VAULT_APPROLE_SECRET_ID
    }
  }
  client_auth {
    cert_file = var.LOCAL_FILE_VAULT_CLIENT_CHAIN_CERTIFICATE
    key_file  = var.LOCAL_FILE_VAULT_CLIENT_PRIVATE_KEY
  }
}

provider "github" {
  alias = "arpanrec"
  owner = "arpanrec"
  token = local.GH_PROD_API_TOKEN
}
