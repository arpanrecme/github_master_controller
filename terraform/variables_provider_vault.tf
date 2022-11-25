variable "VAULT_APPROLE_AUTH_MOUNT" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_APPROLE_AUTH_MOUNT) > 1
    error_message = "Missing vault approle mount point"
  }
}

variable "VAULT_APPROLE_ID" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_APPROLE_ID) > 1
    error_message = "Missing vault username"
  }
}

variable "VAULT_APPROLE_SECRET_ID" {
  type      = string
  default   = null
  sensitive = true
  validation {
    condition     = length(var.VAULT_APPROLE_SECRET_ID) > 1
    error_message = "Missing vault password"
  }
}

variable "LOCAL_FILE_ROOT_CA_CERTIFICATE" {
  type      = string
  default   = "root_ca_certificate.pem"
  sensitive = true
  validation {
    condition     = length(var.LOCAL_FILE_ROOT_CA_CERTIFICATE) > 1
    error_message = "Missing root certificate path"
  }
}

variable "LOCAL_FILE_VAULT_CLIENT_CHAIN_CERTIFICATE" {
  type      = string
  default   = "vault_client_chain_certificate.pem"
  sensitive = true
  validation {
    condition     = length(var.LOCAL_FILE_VAULT_CLIENT_CHAIN_CERTIFICATE) > 1
    error_message = "Missing client certificate path"
  }
}

variable "LOCAL_FILE_VAULT_CLIENT_PRIVATE_KEY" {
  type      = string
  default   = "vault_client_private_key.pem"
  sensitive = true
  validation {
    condition     = length(var.LOCAL_FILE_VAULT_CLIENT_PRIVATE_KEY) > 1
    error_message = "Missing client certificate key path"
  }
}
