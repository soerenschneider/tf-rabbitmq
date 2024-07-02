resource "rabbitmq_binding" "test" {
  for_each = { for i, binding in var.bindings : i => binding }
  depends_on = [
    rabbitmq_exchange.test,
    rabbitmq_queue.test
  ]
  vhost            = var.vhost
  source           = each.value.source
  destination      = each.value.dest
  destination_type = each.value.dest_type
  routing_key      = each.value.routing_key
  arguments_json   = each.value.arguments_json
}
