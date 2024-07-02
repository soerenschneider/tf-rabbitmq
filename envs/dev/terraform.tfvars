queues = [
  {
    name = "hermes"
  },
  {
    name = "fetcharr"
  }
]
exchanges = [
  {
    name    = "fetcharr",
    type    = "fanout",
    durable = true
  },
  {
    name    = "hermes",
    type    = "fanout",
    durable = true
  }
]
bindings = [
  {
    source    = "fetcharr"
    dest      = "fetcharr"
    dest_type = "queue"
  },
  {
    source    = "hermes"
    dest      = "hermes"
    dest_type = "queue"
  }
]
users = [
  {
    username = "producer",
    password = "zzzzzzzzzzzzzzzzzzzzzzzzzzz",
    permissions = [
      {
        configure = "hermes.*"
        write     = "hermes.*"
        read      = ".*"
      }
    ]
  },
  {
    username = "consumer",
    password = "zzzzzzzzzzzzzzzzzzzzzzzzzzz",
    permissions = [
      {
        configure = "hermes.*"
        write     = "hermes.*"
        read      = "hermes.*"
      }
    ]
  },
  {
    username = "fetcharr",
    password = "blasdasdgsadgasdasdgasdfa",
    permissions = [
      {
        configure = "fetcharr.*"
        write     = "fetcharr.*"
        read      = "fetcharr.*"
      }
    ]
  }
]
