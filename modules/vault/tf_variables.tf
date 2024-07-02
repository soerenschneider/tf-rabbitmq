variable "credentials" {
  type = list(
    object({
      username = string,
      password = string
  }))

  description = "A list of credentials to store, each containing a username and a corresponding password."
}

variable "vault_kv2_mount" {
  type    = string
  default = "secret"

  validation {
    condition     = !endswith(var.vault_kv2_mount, "/") && length(var.vault_kv2_mount) > 3
    error_message = "vault_kv2_mount should not end with a slash."
  }

  description = "Specifies the mount point for the Vault KV2 (Key-Value) secrets engine. This is the base path where secrets will be stored."
}

variable "path_prefix" {
  type    = string
  default = "rabbitmq"

  validation {
    condition     = length(var.path_prefix) >= 3
    error_message = "path_prefix must be more than 2 characters."
  }

  validation {
    condition     = !(startswith(var.path_prefix, "/") || endswith(var.path_prefix, "/"))
    error_message = "Invalid path_prefix: must not start or end with a slash ('/')."
  }

  description = "Defines the prefix for paths where secrets will be stored in Vault."
}

variable "metadata" {
  type    = map(any)
  default = null

  description = "An optional set of key-value pairs to attach as metadata to the secrets stored in Vault."
}
