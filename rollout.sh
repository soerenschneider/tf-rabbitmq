#!/usr/bin/env bash

set -e

ENV="${1:-prod}"

echo "Running tofu apply for env ${ENV}"

RABBITMQ_SECRET_PATH="infra/selfhosted/rabbitmq-${ENV}"
TF_SECRET_PATH="infra/selfhosted/terraform-state/tf-rabbitmq-${ENV}"

echo "Reading rabbitmq credentials..."
OUTPUT=$(pass "${RABBITMQ_SECRET_PATH}")
RABBITMQ_USERNAME=$(echo "${OUTPUT}" | grep ^RABBITMQ_USERNAME= | cut -d'=' -f2)
export RABBITMQ_USERNAME

RABBITMQ_PASSWORD=$(echo "${OUTPUT}" | grep ^RABBITMQ_PASSWORD= | cut -d'=' -f2)
export RABBITMQ_PASSWORD

echo "Reading opentofu state encryption key..."
OUTPUT=$(pass "${TF_SECRET_PATH}")
_TF_KEY=$(echo "${OUTPUT}" | head -n1)
export _TF_KEY

TF_ENCRYPTION=$(cat <<EOF
key_provider "pbkdf2" "mykey" {
  passphrase = "${_TF_KEY}"
}
EOF
)
export TF_ENCRYPTION

terragrunt --terragrunt-working-dir="envs/${ENV}" apply
