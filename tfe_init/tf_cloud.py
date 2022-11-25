#!/usr/bin/env python3

import os
import sys
import json
import tempfile
import hvac
import requests
import hcl
from hashicorp_tfe_core import crud


def get_tf_token_from_vault(global_config=None) -> str:
    """get_tf_token_from_vault"""
    print("TF_PROD_TOKEN not found in environment, reading vault")

    __vault_approle_mount_point = os.getenv("VAULT_APPROLE_AUTH_MOUNT", None)
    if not __vault_approle_mount_point:
        raise Exception("missing VAULT_APPROLE_AUTH_MOUNT")

    __vault_approle_id = os.getenv("VAULT_APPROLE_ID", None)
    if not __vault_approle_id:
        raise Exception("missing vault_approle_id")

    __vault_approle_secret_id = os.getenv("VAULT_APPROLE_SECRET_ID", None)
    if not __vault_approle_secret_id:
        raise Exception("missing vault_approle_secret_id")

    __root_ca_certificate = os.getenv("ROOT_CA_CERTIFICATE", None)
    if not __root_ca_certificate:
        raise Exception("missing Root CA Certificate")
    with tempfile.NamedTemporaryFile(delete=False) as temp_root_ca_certificate:
        __local_file_root_ca_certificate = temp_root_ca_certificate.name
        temp_root_ca_certificate.write(bytes(__root_ca_certificate, "utf-8"))

    __vault_client_chain_certificate = os.getenv("VAULT_CLIENT_CHAIN_CERTIFICATE", None)
    if not __vault_client_chain_certificate:
        raise Exception("missing VAULT_CLIENT_CHAIN_CERTIFICATE")
    with tempfile.NamedTemporaryFile(delete=False) as temp_vault_client_chain_certificate:
        __local_file_vault_client_chain_certificate = temp_vault_client_chain_certificate.name
        temp_vault_client_chain_certificate.write(bytes(__vault_client_chain_certificate, "utf-8"))

    __vault_client_private_key = os.getenv("VAULT_CLIENT_PRIVATE_KEY", None)
    if not __vault_client_private_key:
        raise Exception("missing VAULT_CLIENT_PRIVATE_KEY")
    with tempfile.NamedTemporaryFile(delete=False) as temp_vault_client_private_key:
        __local_file_vault_client_private_key = temp_vault_client_private_key.name
        temp_vault_client_private_key.write(bytes(__vault_client_private_key, "utf-8"))

    _vault_addr = f"{global_config['VAULT']['PROTOCOL']}://{global_config['VAULT']['FQDN']}:{global_config['VAULT']['PORT']}"
    client = hvac.Client(
        url=_vault_addr,
        verify=__local_file_root_ca_certificate,
        cert=(
            __local_file_vault_client_chain_certificate,
            __local_file_vault_client_private_key,
        ),
    )

    client.auth.approle.login(
        role_id=__vault_approle_id,
        secret_id=__vault_approle_secret_id,
        mount_point=__vault_approle_mount_point,
    )
    secret_version_response = client.secrets.kv.v2.read_secret_version(
        path="terraform_cloud", mount_point="prerequisite"
    )
    __tf_prod_token = secret_version_response["data"]["data"]["TF_PROD_TOKEN"]
    client.logout()

    return __tf_prod_token


def main(backend_filename=None, terraform_directory=None):
    if not backend_filename:
        raise Exception(
            "Terraform Remote Backend Filename is missing, pass the file path as CLI argument"
        )

    if not terraform_directory:
        raise Exception(
            "Terraform directory is missing, pass the file path as CLI argument"
        )

    __global_config_endpoint = os.getenv("GLOBAL_CONFIG_ENDPOINT", None)
    if not __global_config_endpoint:
        raise Exception("Missing GLOBAL_CONFIG_ENDPOINT")

    global_config = requests.get(__global_config_endpoint, timeout=30).json()

    __tf_prod_token = os.getenv("TF_PROD_TOKEN", None)

    if not __tf_prod_token:
        __tf_prod_token = get_tf_token_from_vault(global_config)

    if not __tf_prod_token:
        raise Exception("__tf_prod_token is missing")

    with open(
        os.path.join(terraform_directory, backend_filename), "r", encoding="utf-8"
    ) as terraform_backend_file_stream:
        backend_hcl = hcl.load(terraform_backend_file_stream)
    terraform_workspace = backend_hcl["terraform"]["backend"]["remote"]["workspaces"][
        "name"
    ]
    terraform_org = global_config["TERRAFORM_CLOUD"]["ORGANIZATION"]
    terraform_hostname = global_config["TERRAFORM_CLOUD"]["HOSTNAME"]
    ws_res = crud(
        hostname=terraform_hostname,
        organization=terraform_org,
        organization_attributes={
            "email": global_config["EMAIL"],
            "collaborator-auth-policy": global_config["TERRAFORM_CLOUD"]["AUTH_POLICY"],
        },
        workspace=terraform_workspace,
        workspace_attributes={
            "allow-destroy-plan": True,
            "auto-apply": True,
            "execution-mode": "local",
        },
        token=__tf_prod_token,
    )
    print(json.dumps(ws_res, indent=4))


if __name__ == "__main__":
    main(backend_filename=sys.argv[2], terraform_directory=sys.argv[1])
