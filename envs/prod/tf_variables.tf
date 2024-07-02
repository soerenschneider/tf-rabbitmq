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
}

variable "queues" {
  type = list(object({
    name        = string
    durable     = optional(bool)
    auto_delete = optional(bool)
    arguments   = optional(map(any))
  }))
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
}

variable "exchanges" {
  type = list(object({
    name        = string
    type        = string
    durable     = optional(bool)
    auto_delete = optional(bool)
  }))

  default = []
}
