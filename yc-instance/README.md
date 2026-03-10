## Overview

Terraform-модуль для создания виртуальной машины в Yandex Cloud (YC) с поддержкой:
- нескольких сетевых интерфейсов,
- дополнительных дисков,
- cloud-init (`user-data`),
- опционального создания DNS-записей в YC DNS.

## Requirements

- **Terraform**: `>= 1.9.8`
- **Provider**: `yandex-cloud/yandex` `0.176.0` (зафиксирован в модуле)

## Inputs

- **`platform_id`** (`string`, required): platform id для VM (например, `"standard-v1"`).
- **`zone`** (`string`, required): зона YC (например, `"ru-central1-a"`).
- **`folder_id`** (`string`, required): folder id (используется для поиска DNS-зоны).
- **`name`** (`string`, optional, default `"yc-instance"`): имя VM.
- **`os_name`** (`string`, optional, default `"ubuntu-2404-lts"`): family образа для `data.yandex_compute_image` (образ берётся по family, а не по `image_id`).

- **`core_fraction`** (`number`, optional, default `20`): доля CPU.
- **`cores`** (`number`, optional, default `2`): vCPU.
- **`memory`** (`number`, optional, default `2`): RAM в ГБ.

- **`ssh`** (`string`, optional): значение для metadata `ssh-keys` (nullable).
- **`tags`** (`list(string)`, optional, default `[]`): список тегов (используется для metadata `tags`).
- **`labels`** (`map(string)`, optional, default `{}`): labels ресурса.

- **`network_interfaces`** (`list(object)`, optional): список NIC:
  - `subnet_id` (`string`, required)
  - `nat` (`bool`, required)
  - `ip_address` (`string`, optional)
  - `security_group` (`set(string)`, optional)
  По умолчанию создаётся один интерфейс `{ subnet_id = "", nat = true }` (обычно нужно переопределить `subnet_id`).

- **`boot_disk`** (`object({ type = string, size = number })`, required): параметры загрузочного диска. Образ выбирается по `os_name`.
- **`additional_disks`** (`list(object({ size = number, type = string }))`, optional, default `[]`): дополнительные диски.

- **`cloud_init`** (`string`, optional): YAML содержимое для cloud-init (nullable).

- **`create_dns_record`** (`bool`, optional, default `false`): создавать DNS-записи.
- **`dns_zone_name`** (`string`, optional, default `""`): имя DNS-зоны (используется для `data.yandex_dns_zone`).
- **`dns_records`** (`map(object({ name = string, ttl = number, type = string }))`, optional, default `{}`): записи, которые будут созданы. Сейчас `data` всегда указывает на NAT IP первого интерфейса.

- **`wait_timeout`** (`number`, optional, default `300`): таймаут ожидания SSH (используется `null_resource` + `nc`).

## Outputs

- **`instance_id`**: ID созданного инстанса.
- **`public_ips`**: список с NAT IP первого интерфейса.
- **`private_ips`**: список с приватным IP первого интерфейса.
- **`tags`**: значение `var.tags`.
- **`instance_name`**: имя инстанса.
- **`fqdn`**: список имён записей, если DNS создавался, иначе `[]`.

## Example

```hcl
module "vm" {
  source = "../yc-instance"

  folder_id = "your-folder-id"
  zone      = "ru-central1-a"
  name      = "app-server-01"

  platform_id = "standard-v1"
  os_name     = "ubuntu-2404-lts"

  boot_disk = {
    type = "network-ssd"
    size = 50
  }

  cores  = 2
  memory = 4

  ssh = file("~/.ssh/id_rsa.pub")

  network_interfaces = [
    {
      subnet_id = "your-subnet-id"
      nat       = true
    }
  ]

  tags = ["app", "production"]

  create_dns_record = true
  dns_zone_name     = "example-com"
  dns_records = {
    www = {
      name = "app.example.com."
      ttl  = 300
      type = "A"
    }
  }
}
```

## Usage notes

- Обязательные поля: `platform_id`, `folder_id`, `zone`, `boot_disk`.
- Образ выбирается по `os_name` (image family), а не по `image_id`.
- DNS сейчас создаёт A-запись на NAT IP **первого** сетевого интерфейса (`network_interface[0].nat_ip_address`).