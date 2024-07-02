variable "users" {
  type = list(object({
    username = string,
    password = optional(string),
    tags     = optional(list(string)),
    permissions = list(object({
      configure = string
      write     = string
      read      = string
    }))
  }))

  description = "List of users to be created in RabbitMQ."
}

variable "queues" {
  type = list(object({
    name        = string
    durable     = optional(bool)
    auto_delete = optional(bool)
    arguments   = optional(map(any))
  }))

  description = "Defines a list of queues to be created in RabbitMQ."
}

variable "bindings" {
  type = list(object({
    source         = string
    dest           = string
    dest_type      = string
    arguments_json = optional(string)
    routing_key    = optional(string)
  }))

  default     = []
  description = "Specifies the bindings between RabbitMQ exchanges and queues or other exchanges."
}

variable "exchanges" {
  type = list(object({
    name        = string
    type        = string
    durable     = optional(bool)
    auto_delete = optional(bool)
  }))

  default     = []
  description = "A list of exchanges to be set up in RabbitMQ."
}
