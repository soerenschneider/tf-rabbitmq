locals {
  sops_file = "${get_original_terragrunt_dir()}/tg_variables.sops.yaml"
  secret_vars = yamldecode(sops_decrypt_file(local.sops_file))
}

inputs = merge(
  local.secret_vars,
  {}
)
