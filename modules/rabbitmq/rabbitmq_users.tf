resource "rabbitmq_user" "test" {
  for_each = { for i, user in var.users : user.username => user }
  name     = each.key
  password = each.value.password
  tags     = coalesce(each.value.tags, [])
}

resource "rabbitmq_permissions" "guest" {
  for_each = {
    for i, user in var.users : user.username => user
  }
  depends_on = [
    rabbitmq_user.test
  ]
  user  = each.key
  vhost = var.vhost

  dynamic "permissions" {
    for_each = each.value.permissions
    content {
      configure = permissions.value["configure"]
      write     = permissions.value["write"]
      read      = permissions.value["read"]
    }
  }
}
