# tf-rabbitmq

![terratest](https://github.com/soerenschneider/tf-rabbitmq/actions/workflows/terratest.yaml/badge.svg)
![lint-workflow](https://github.com/soerenschneider/tf-rabbitmq/actions/workflows/lint.yaml/badge.svg)
![security-workflow](https://github.com/soerenschneider/tf-rabbitmq/actions/workflows/security.yaml/badge.svg)

This repository implements Infrastructure as Code (IaC) using [OpenTofu](https://opentofu.org/) to configure RabbitMQ clusters and write user credentials to Hashicorp Vault.

## Table of Contents

- [Overview](#overview)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)

## Getting Started

Follow these instructions to set up the repository and start managing your RabbitMQ and Vault resources.

### Prerequisites

- [OpenTofu](https://opentofu.org/)
- Docker-compose

### Running the code

1. **Clone the repository:**
   ```bash
   git clone https://github.com/soerenschneider/tf-rabbitmq.git
   cd tf-rabbitmq
   ```

2. **Provisioning resources:**
   ```bash
   cd envs/dev
   bash run.sh
   ```

### Tests

This repository utilizes Terratest for automated testing of OpenTofu modules and configurations.

1. **Running the tests:**
   ```bash
   $ make tests
   ```
