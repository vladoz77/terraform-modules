## Overview

Terraform-модуль для создания одной security group в Yandex Cloud (YC) с поддержкой:
- ingress-правил,
- egress-правил,
- описания и имени группы.

## Requirements

- **Terraform**: `>= 1.9.8`
- **Provider**: `yandex-cloud/yandex` `0.176.0` (зафиксирован в модуле)

## Inputs

- **`network_id`** (`string`, required): ID VPC-сети, в которой будет создана security group.
- **`sg_name`** (`string`, required): имя security group.
- **`sg_description`** (`string`, required): описание security group.

- **`ingress_rules`** (`map(object)`, optional, default `{}`): набор входящих правил. Ключ map используется только как удобный идентификатор правила.
  Поддерживаемые поля объекта:
  - `protocol` (`string`, required)
  - `description` (`string`, required)
  - `port` (`number`, optional)
  - `from_port` (`number`, optional)
  - `to_port` (`number`, optional)
  - `v4_cidr_blocks` (`list(string)`, optional)
  - `predefined_target` (`string`, optional)

- **`egress_rules`** (`map(object)`, optional, default `{}`): набор исходящих правил с той же схемой, что и `ingress_rules`.

## Outputs

- **`security_group_id`**: ID созданной security group.
- **`security_group_name`**: имя созданной security group.

## Example

```hcl
module "network" {
  source = "../yc-network"

  zone         = "ru-central1-a"
  network_name = "app-network"
  subnet_name  = "app-subnet"
  ipv4_cidr    = ["10.10.0.0/24"]
}

module "security_group" {
  source = "../yc-security-groups"

  network_id      = module.network.network_id
  sg_name         = "app-security-group"
  sg_description  = "Security group for app servers"

  ingress_rules = {
    ssh = {
      protocol       = "TCP"
      port           = 22
      v4_cidr_blocks = ["203.0.113.10/32"]
      description    = "SSH from admin host"
    }

    http = {
      protocol       = "TCP"
      port           = 80
      v4_cidr_blocks = ["0.0.0.0/0"]
      description    = "HTTP from anywhere"
    }

    https = {
      protocol       = "TCP"
      port           = 443
      v4_cidr_blocks = ["0.0.0.0/0"]
      description    = "HTTPS from anywhere"
    }
  }

  egress_rules = {
    https_out = {
      protocol       = "TCP"
      port           = 443
      v4_cidr_blocks = ["0.0.0.0/0"]
      description    = "HTTPS to the internet"
    }

    dns_tcp = {
      protocol       = "TCP"
      port           = 53
      v4_cidr_blocks = ["0.0.0.0/0"]
      description    = "DNS over TCP"
    }

    dns_udp = {
      protocol       = "UDP"
      port           = 53
      v4_cidr_blocks = ["0.0.0.0/0"]
      description    = "DNS over UDP"
    }
  }
}
```

## Usage notes

- Модуль создаёт только одну security group.
- Если `ingress_rules` или `egress_rules` пустые, соответствующие правила не будут созданы.
- Для правил можно использовать либо `port`, либо диапазон `from_port` / `to_port`, в зависимости от сценария.
- Сейчас модуль прокидывает только те поля правил, которые описаны во входных переменных: `protocol`, `port`, `from_port`, `to_port`, `v4_cidr_blocks`, `description`, `predefined_target`.
