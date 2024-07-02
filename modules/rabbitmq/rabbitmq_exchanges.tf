resource "rabbitmq_exchange" "test" {
  for_each = { for i, exchange in var.exchanges : exchange.name => exchange }
  name     = each.key
  vhost    = var.vhost

  settings {
    type        = each.value.type
    durable     = each.value.durable
    auto_delete = each.value.auto_delete
  }
}
