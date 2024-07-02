variable "vhost" {
  type        = string
  description = "Specifies the RabbitMQ virtual host (vhost) where resources such as queues, exchanges, and bindings will be created."
}

variable "queues" {
  type = list(object({
    name        = string
    durable     = optional(bool)
    auto_delete = optional(bool)
    arguments   = optional(map(any))
  }))

  default     = []
  description = "Defines a list of queues to be created in the RabbitMQ virtual host. Each queue can have additional attributes."
}

variable "exchanges" {
  type = list(object({
    name        = string
    type        = string
    durable     = optional(bool)
    auto_delete = optional(bool)
  }))

  default = []

  validation {
    condition     = alltrue([for x in var.exchanges : contains(["fanout", "direct", "topic", "headers"], x.type)])
    error_message = "Invalid type provided, only 'fanout', 'direct', 'topic', and 'headers' are allowed."
  }

  description = "Specifies the list of exchanges to be set up in the RabbitMQ virtual host. Exchanges route messages to queues based on routing rules."
}

variable "bindings" {
  type = list(object({
    source         = string
    dest           = string
    dest_type      = string
    arguments_json = optional(string)
    routing_key    = optional(string)
  }))

  default = []

  validation {
    condition     = alltrue([for x in var.bindings : contains(["queue", "exchange"], x.dest_type)])
    error_message = "Invalid dest_type provided, only 'queue' or 'exchange' are allowed."
  }

  description = "Defines the bindings between exchanges and queues or other exchanges in RabbitMQ."
}

variable "users" {
  type = list(object({
    username = string,
    password = string,
    tags     = optional(list(string)),
    permissions = list(object({
      configure = string
      write     = string
      read      = string
    }))
  }))

  default = []

  validation {
    condition     = alltrue(flatten([for x in var.users : [for tag in coalesce(x.tags, []) : contains(["management", "policymaker", "monitoring", "administrator"], tag)]]))
    error_message = "Invalid tags provided."
  }

  validation {
    condition     = alltrue([for x in var.users : length(x.permissions) >= 1])
    error_message = "Permissions must be set."
  }

  validation {
    condition     = alltrue([for x in var.users : x.password == null ? true : length(x.password) >= 20])
    error_message = "Password must be at least 20 characters long."
  }

  description = "Creates RabbitMQ users and assigns their permissions within the virtual host."
}
