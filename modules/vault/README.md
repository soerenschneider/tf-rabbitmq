<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_vault"></a> [vault](#requirement\_vault) | 4.2.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_vault"></a> [vault](#provider\_vault) | 4.2.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [vault_kv_secret_v2.users](https://registry.terraform.io/providers/hashicorp/vault/4.2.0/docs/resources/kv_secret_v2) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_credentials"></a> [credentials](#input\_credentials) | A list of credentials to store, each containing a username and a corresponding password. | <pre>list(<br/>    object({<br/>      username = string,<br/>      password = string<br/>  }))</pre> | n/a | yes |
| <a name="input_metadata"></a> [metadata](#input\_metadata) | An optional set of key-value pairs to attach as metadata to the secrets stored in Vault. | `map(any)` | `null` | no |
| <a name="input_path_prefix"></a> [path\_prefix](#input\_path\_prefix) | Defines the prefix for paths where secrets will be stored in Vault. | `string` | `"rabbitmq"` | no |
| <a name="input_vault_kv2_mount"></a> [vault\_kv2\_mount](#input\_vault\_kv2\_mount) | Specifies the mount point for the Vault KV2 (Key-Value) secrets engine. This is the base path where secrets will be stored. | `string` | `"secret"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->