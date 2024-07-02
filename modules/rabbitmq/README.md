<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6.0 |
| <a name="requirement_rabbitmq"></a> [rabbitmq](#requirement\_rabbitmq) | 1.8.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_rabbitmq"></a> [rabbitmq](#provider\_rabbitmq) | 1.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [rabbitmq_binding.test](https://registry.terraform.io/providers/cyrilgdn/rabbitmq/1.8.0/docs/resources/binding) | resource |
| [rabbitmq_exchange.test](https://registry.terraform.io/providers/cyrilgdn/rabbitmq/1.8.0/docs/resources/exchange) | resource |
| [rabbitmq_permissions.guest](https://registry.terraform.io/providers/cyrilgdn/rabbitmq/1.8.0/docs/resources/permissions) | resource |
| [rabbitmq_queue.test](https://registry.terraform.io/providers/cyrilgdn/rabbitmq/1.8.0/docs/resources/queue) | resource |
| [rabbitmq_user.test](https://registry.terraform.io/providers/cyrilgdn/rabbitmq/1.8.0/docs/resources/user) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bindings"></a> [bindings](#input\_bindings) | Defines the bindings between exchanges and queues or other exchanges in RabbitMQ. | <pre>list(object({<br>    source         = string<br>    dest           = string<br>    dest_type      = string<br>    arguments_json = optional(string)<br>    routing_key    = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_exchanges"></a> [exchanges](#input\_exchanges) | Specifies the list of exchanges to be set up in the RabbitMQ virtual host. Exchanges route messages to queues based on routing rules. | <pre>list(object({<br>    name        = string<br>    type        = string<br>    durable     = optional(bool)<br>    auto_delete = optional(bool)<br>  }))</pre> | `[]` | no |
| <a name="input_queues"></a> [queues](#input\_queues) | Defines a list of queues to be created in the RabbitMQ virtual host. Each queue can have additional attributes. | <pre>list(object({<br>    name        = string<br>    durable     = optional(bool)<br>    auto_delete = optional(bool)<br>    arguments   = optional(map(any))<br>  }))</pre> | `[]` | no |
| <a name="input_users"></a> [users](#input\_users) | Creates RabbitMQ users and assigns their permissions within the virtual host. | <pre>list(object({<br>    username = string,<br>    password = string,<br>    tags     = optional(list(string)),<br>    permissions = list(object({<br>      configure = string<br>      write     = string<br>      read      = string<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_vhost"></a> [vhost](#input\_vhost) | Specifies the RabbitMQ virtual host (vhost) where resources such as queues, exchanges, and bindings will be created. | `string` | n/a | yes |

## Outputs

No outputs.
<!-- END_TF_DOCS -->