# GitHub Repository Management

## Required Variables

Environment Variables

- `GLOBAL_CONFIG_ENDPOINT`: Global configuration endpoint.
- `VAULT_APPROLE_AUTH_MOUNT`: Vault Approle Mount Path.
- `VAULT_APPROLE_ID`: Vault Approle Login ID.
- `VAULT_APPROLE_SECRET_ID`: Vault Approle Login secret ID.
- `ROOT_CA_CERTIFICATE`: Root CA Certificate Content.
- `VAULT_CLIENT_CHAIN_CERTIFICATE`: Vault client certificate full chain content.
- `VAULT_CLIENT_PRIVATE_KEY`: Vault client key content.

## Terraform

### Working Directory

`terraform`

### Backend

Terraform remote backend in terraform cloud

- Hostname: `app.terraform.io`
- Organization: `arpanrecme`
  - Workspace: `github_repo_management`
    - execution-mode: `local`

### Files and Naming

`backend.tf` -> Terraform HTTP Backend

`provider.tf` -> Providers Setup

`vars.tf` -> Variables

`repo-<repository_name>.tf` -> Repository Description

## Local Development

working-directory: `./terraform`

### Terraform init

```bash
terraform init \
  --backend-config="token=<Terraform Cloud Token>" \
  --backend-config="hostname=<Terraform Cloud Hostname>" \
  --backend-config="organization=<Terraform Cloud Organization>"
```

```bash
terraform init \
  --backend-config="token=$(cat "${LOCAL_FILE_TF_PROD_TOKEN}")" \
  --backend-config="hostname=$(cat "${LOCAL_FILE_TERRAFORM_CLOUD_HOSTNAME}")" \
  --backend-config="organization=$(cat "${LOCAL_FILE_TERRAFORM_CLOUD_ORGANIZATION}")"
```

### Make changes and plan the changes with `terraform plan`

```shell
terraform plan -input=false -out="./tfplan"
```

### Apply the changes with `terraform apply`

```shell
terraform apply "./tfplan"
```

## License

`MIT`
