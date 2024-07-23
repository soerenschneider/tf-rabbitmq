locals {
  sops_file = "${get_original_terragrunt_dir()}/tg_variables.sops.yaml"
  secret_vars = yamldecode(sops_decrypt_file(local.sops_file))
}

include "root" {
  path = find_in_parent_folders()
}

inputs = merge(
  local.secret_vars,
  {}
)
