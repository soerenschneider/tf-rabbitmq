resource "rabbitmq_queue" "test" {
  for_each = { for i, val in var.queues : val.name => val }
  name     = each.key
  vhost    = var.vhost

  settings {
    durable     = coalesce(each.value.durable, false)
    auto_delete = coalesce(each.value.auto_delete, false)
    arguments   = each.value.arguments
  }
}
