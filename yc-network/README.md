## Overview

Terraform-модуль для создания сетевой инфраструктуры в Yandex Cloud (YC) с поддержкой:
- VPC-сети,
- одной подсети,
- опционального создания статического внешнего IPv4-адреса.

## Requirements

- **Terraform**: `>= 1.9.8`
- **Provider**: `yandex-cloud/yandex` `0.176.0` (зафиксирован в модуле)

## Inputs

- **`zone`** (`string`, required): зона YC для подсети и статического адреса (например, `"ru-central1-a"`).
- **`network_name`** (`string`, required): имя VPC-сети.
- **`subnet_name`** (`string`, required): имя подсети.
- **`ipv4_cidr`** (`list(string)`, required): список IPv4 CIDR-блоков для подсети.

- **`static_address`** (`object`, optional, default `null`): конфигурация статического внешнего IPv4-адреса. Если `null`, адрес не создаётся.
  - `name` (`string`, optional): имя статического адреса.
  - `deletion_protection` (`bool`, optional, default `false`): защита адреса от удаления.

## Outputs

- **`network_id`**: ID созданной VPC-сети.
- **`subnet_id`**: ID созданной подсети.
- **`network_cidr`**: первый CIDR-блок подсети.
- **`static_address_id`**: ID статического внешнего IP-адреса, если он создавался.
- **`static_external_ipv4_address`**: внешний IPv4-адрес, если он создавался.

## Example

```hcl
module "network" {
  source = "../yc-network"

  zone         = "ru-central1-a"
  network_name = "app-network"
  subnet_name  = "app-subnet"
  ipv4_cidr    = ["10.10.0.0/24"]

  static_address = {
    name                = "app-public-ip"
    deletion_protection = true
  }
}
```

## Usage notes

- Если `static_address = null`, ресурс `yandex_vpc_address` не создаётся.
- Статический адрес создаётся в той же зоне, что и `var.zone`.
- Значение `static_external_ipv4_address` можно использовать в другом модуле, например передавать в `yc-instance` как `network_interfaces[*].nat_ip_address`.
