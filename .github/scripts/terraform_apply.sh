#!/usr/bin/env bash
set -eo pipefail

export TF_VAR_GLOBAL_CONFIG_ENDPOINT=${TF_VAR_GLOBAL_CONFIG_ENDPOINT:-$GLOBAL_CONFIG_ENDPOINT}
export TF_VAR_VAULT_APPROLE_AUTH_MOUNT=${TF_VAR_VAULT_APPROLE_AUTH_MOUNT:-$VAULT_APPROLE_AUTH_MOUNT}
export TF_VAR_VAULT_APPROLE_ID=${TF_VAR_VAULT_APPROLE_ID:-$VAULT_APPROLE_ID}
export TF_VAR_VAULT_APPROLE_SECRET_ID=${TF_VAR_VAULT_APPROLE_SECRET_ID:-$VAULT_APPROLE_SECRET_ID}
export TF_VAR_LOCAL_FILE_ROOT_CA_CERTIFICATE=${TF_VAR_LOCAL_FILE_ROOT_CA_CERTIFICATE:-"root_ca_certificate.pem"}
export TF_VAR_LOCAL_FILE_VAULT_CLIENT_CHAIN_CERTIFICATE=${TF_VAR_LOCAL_FILE_VAULT_CLIENT_CHAIN_CERTIFICATE:-"vault_client_chain_certificate.pem"}
export TF_VAR_LOCAL_FILE_VAULT_CLIENT_PRIVATE_KEY=${TF_VAR_LOCAL_FILE_VAULT_CLIENT_PRIVATE_KEY:-"vault_client_private_key.pem"}
export LOCAL_FILE_TERRAFORM_CLOUD_ORGANIZATION=${LOCAL_FILE_TERRAFORM_CLOUD_ORGANIZATION:-"tfe_org.txt"}
export LOCAL_FILE_TERRAFORM_CLOUD_HOSTNAME=${LOCAL_FILE_TERRAFORM_CLOUD_HOSTNAME:-"tfe_hostname.txt"}
export LOCAL_FILE_VAULT_TOKEN=${LOCAL_FILE_VAULT_TOKEN:-".vault-token.txt"}
export LOCAL_FILE_TF_PROD_TOKEN=${LOCAL_FILE_TF_PROD_TOKEN:-".tf_prod_token.txt"}

_global_config=$(curl -s "${TF_VAR_GLOBAL_CONFIG_ENDPOINT}")

_vault_proto=$(echo "${_global_config}" | jq -r '.VAULT | .PROTOCOL')
_vault_domain=$(echo "${_global_config}" | jq -r '.VAULT | .FQDN')
_vault_port=$(echo "${_global_config}" | jq -r '.VAULT | .PORT')

_vault_addr="${_vault_proto}://${_vault_domain}:${_vault_port}"

echo -n "${ROOT_CA_CERTIFICATE}" >"${TF_VAR_LOCAL_FILE_ROOT_CA_CERTIFICATE}"
echo -n "${VAULT_CLIENT_CHAIN_CERTIFICATE}" >"${TF_VAR_LOCAL_FILE_VAULT_CLIENT_CHAIN_CERTIFICATE}"
echo -n "${VAULT_CLIENT_PRIVATE_KEY}" >"${TF_VAR_LOCAL_FILE_VAULT_CLIENT_PRIVATE_KEY}"

_approle_auth_payload=$(jq --null-input \
    --arg role_id "$TF_VAR_VAULT_APPROLE_ID" \
    --arg secret_id "$TF_VAR_VAULT_APPROLE_SECRET_ID" \
    '{"role_id": $role_id, "secret_id": $secret_id}')

echo -n "$(curl --request POST --silent \
    "${_vault_addr}"/v1/auth/"${TF_VAR_VAULT_APPROLE_AUTH_MOUNT}"/login \
    --cert "${TF_VAR_LOCAL_FILE_VAULT_CLIENT_CHAIN_CERTIFICATE}" \
    --key "${TF_VAR_LOCAL_FILE_VAULT_CLIENT_PRIVATE_KEY}" \
    --cacert "${TF_VAR_LOCAL_FILE_ROOT_CA_CERTIFICATE}" \
    --header 'Content-Type: application/json' \
    --data-raw "${_approle_auth_payload}" | jq -r '.auth | .client_token')" >"${LOCAL_FILE_VAULT_TOKEN}"
echo "::add-mask::$(cat "${LOCAL_FILE_VAULT_TOKEN}")"

echo -n "$(curl --request GET --silent \
    "${_vault_addr}"/v1/prerequisite/data/terraform_cloud \
    --cert "${TF_VAR_LOCAL_FILE_VAULT_CLIENT_CHAIN_CERTIFICATE}" \
    --key "${TF_VAR_LOCAL_FILE_VAULT_CLIENT_PRIVATE_KEY}" \
    --cacert "${TF_VAR_LOCAL_FILE_ROOT_CA_CERTIFICATE}" \
    --header 'Content-Type: application/json' \
    --header "X-Vault-Token: $(cat "${LOCAL_FILE_VAULT_TOKEN}")" | jq -r '.data | .data | .TF_PROD_TOKEN')" >"${LOCAL_FILE_TF_PROD_TOKEN}"
echo "::add-mask::$(cat "${LOCAL_FILE_TF_PROD_TOKEN}")"

echo -n "$(echo -n "${_global_config}" | jq -r '.TERRAFORM_CLOUD | .ORGANIZATION')" >"${LOCAL_FILE_TERRAFORM_CLOUD_ORGANIZATION}"
echo -n "$(echo -n "${_global_config}" | jq -r '.TERRAFORM_CLOUD | .HOSTNAME')" >"${LOCAL_FILE_TERRAFORM_CLOUD_HOSTNAME}"

curl --request POST --silent \
    "${_vault_addr}"/v1/auth/token/revoke-self \
    --cert "${TF_VAR_LOCAL_FILE_VAULT_CLIENT_CHAIN_CERTIFICATE}" \
    --key "${TF_VAR_LOCAL_FILE_VAULT_CLIENT_PRIVATE_KEY}" \
    --cacert "${TF_VAR_LOCAL_FILE_ROOT_CA_CERTIFICATE}" \
    --header 'Content-Type: application/json' \
    --header "X-Vault-Token: $(cat "${LOCAL_FILE_VAULT_TOKEN}")"

rm -rf "${LOCAL_FILE_VAULT_TOKEN}"
