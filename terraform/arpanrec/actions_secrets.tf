# resource "vault_pki_secret_backend_cert" "vault_client_certificate" {
#   backend     = "pki"
#   name        = "vault_client_certificate"
#   common_name = local.VAULT_ADDR_DOMAIN_NAME
# }

# resource "github_actions_organization_secret" "global_config_endpoint" {
#   secret_name     = "GLOBAL_CONFIG_ENDPOINT"
#   visibility      = "all"
#   plaintext_value = var.GLOBAL_CONFIG_ENDPOINT
# }

# resource "github_actions_organization_secret" "root_ca_certificate" {
#   secret_name     = "ROOT_CA_CERTIFICATE"
#   visibility      = "all"
#   plaintext_value = vault_pki_secret_backend_cert.vault_client_certificate.ca_chain
# }

# resource "github_actions_organization_secret" "vault_client_chain_certificate" {
#   secret_name = "VAULT_CLIENT_CHAIN_CERTIFICATE"
#   visibility  = "all"
#   plaintext_value = format("%s\n%s",
#     vault_pki_secret_backend_cert.vault_client_certificate.certificate,
#     vault_pki_secret_backend_cert.vault_client_certificate.ca_chain
#   )
# }

# resource "github_actions_organization_secret" "vault_client_private_key" {
#   secret_name     = "VAULT_CLIENT_PRIVATE_KEY"
#   visibility      = "all"
#   plaintext_value = vault_pki_secret_backend_cert.vault_client_certificate.private_key
# }
