locals {
  env = "dev"
}

resource "rabbitmq_vhost" "default" {
  name = local.env
}

module "rabbitmq_prod" {
  source    = "../../modules/rabbitmq"
  vhost     = rabbitmq_vhost.default.name
  queues    = var.queues
  users     = var.users
  exchanges = var.exchanges
  bindings  = var.bindings
}

module "vault" {
  source      = "../../modules/vault"
  credentials = var.users
  path_prefix = "env/${local.env}/rabbitmq"
}
