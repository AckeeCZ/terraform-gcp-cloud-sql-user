#!/bin/bash

export VAULT_ADDR=http://localhost:8200
export VAULT_TOKEN=myroot
export TF_VAR_vault_secret_path=secret/devops/internal/test-cluster

docker run -d --cap-add=IPC_LOCK -e 'VAULT_DEV_ROOT_TOKEN_ID=myroot' --name testing-vault -p 8200:8200 hashicorp/vault

export GOOGLE_PROJECT=terraform-test-hejda
export TF_VAR_namespace=stage
export TF_VAR_region=europe-west3
export TF_VAR_zone=europe-west3-c

export TF_VAR_project=${GOOGLE_PROJECT}

terraform init -upgrade
