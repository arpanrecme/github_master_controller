data "vault_kv_secret_v2" "github_creds" {
  mount = "prerequisite"
  name  = "github"
}

data "http" "global_config" {
  url = var.GLOBAL_CONFIG_ENDPOINT

  # Optional request headers
  request_headers = {
    Content-Type = "application/json"
  }
}

locals {
  VAULT_ADDR_DOMAIN_NAME = jsondecode(data.http.global_config.response_body).VAULT.FQDN
  VAULT_ADDR_PORT        = jsondecode(data.http.global_config.response_body).VAULT.PORT
  VAULT_ADDR_PROTO       = jsondecode(data.http.global_config.response_body).VAULT.PROTOCOL
  VAULT_ADDR             = "${local.VAULT_ADDR_PROTO}://${local.VAULT_ADDR_DOMAIN_NAME}:${local.VAULT_ADDR_PORT}"
  GH_PROD_API_TOKEN      = sensitive(data.vault_kv_secret_v2.github_creds.data["GH_PROD_API_TOKEN"])
}
