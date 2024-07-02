terraform {
  required_version = ">= 1.6.0"

  required_providers {
    rabbitmq = {
      source  = "cyrilgdn/rabbitmq"
      version = "1.8.0"
    }

    vault = {
      source  = "hashicorp/vault"
      version = "4.2.0"
    }
  }

  encryption {
    method "aes_gcm" "default" {
      keys = key_provider.pbkdf2.mykey
    }

    state {
      enforced = true
      method   = method.aes_gcm.default
    }
    plan {
      method   = method.aes_gcm.default
      enforced = true
    }
  }
}

provider "rabbitmq" {
  endpoint = "http://localhost:15672"
  username = "testuser"
  password = "testpass"
}

provider "vault" {
  address = "http://localhost:8200"
  token   = "test"
}
