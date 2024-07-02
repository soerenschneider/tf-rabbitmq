resource "vault_kv_secret_v2" "users" {
  for_each            = { for i, val in var.credentials : i => val }
  mount               = var.vault_kv2_mount
  name                = "${var.path_prefix}/users/${each.value.username}"
  delete_all_versions = true
  data_json = jsonencode(
    {
      password = each.value.password,
    }
  )
  custom_metadata {
    max_versions = 2
    data         = var.metadata
  }
}
