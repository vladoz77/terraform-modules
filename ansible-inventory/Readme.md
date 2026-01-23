# Ansible Inventory Terraform Module

Terraform-модуль для генерации **Ansible inventory файла** на основе переданных групп и хостов.

Модуль использует ресурс `local_file` и шаблон `inventory.tftpl` для формирования классического INI-инвентаря Ansible.

## Назначение

- Генерирует Ansible inventory в формате INI
- Поддерживает любое количество групп
- Принимает списки IP-адресов или хостнеймов
- Удобен для связки **Terraform → Ansible**
- Хорошо работает с **Terragrunt**

## Структура модуля

```text
ansible-inventory/
├── main.tf
├── variables.tf
├── inventory.tftpl
└── README.md
````

## Использование

### Terraform

```hcl
module "ansible_inventory" {
  source = "./modules/ansible-inventory"

  inventory_path = "${path.root}/ansible/prod/inventory.ini"

  groups = {
    blackbox-server = [
      "10.0.0.10",
      "10.0.0.11"
    ]

    monitoring-server = [
      "10.0.1.5"
    ]
  }
}
```

После `terraform apply` будет создан файл:

```bash
ansible/prod/inventory.ini
```

### Terragrunt

```hcl
inputs = {
  inventory_path = "${get_repo_root()}/ansible/prod/inventory.ini"

  groups = {
    blackbox-server   = dependency.blackbox.outputs.public_ips
    monitoring-server = dependency.monitoring.outputs.public_ips
  }
}
```

## Переменные

### `groups`

**Описание:**
Карта Ansible-групп и соответствующих им хостов.

**Тип:**

```hcl
map(list(string))
```

**Пример:**

```hcl
groups = {
  web = ["1.1.1.1", "1.1.1.2"]
  db  = ["2.2.2.2"]
}
```

### `inventory_path`

**Описание:**
Полный путь к inventory-файлу, который будет создан.

**Тип:**

```hcl
string
```

**Пример:**

```hcl
inventory_path = "/home/user/project/ansible/inventory.ini"
```


## Формат inventory

Шаблон `inventory.tftpl` генерирует файл следующего вида:

```ini
[blackbox-server]
10.0.0.10
10.0.0.11

[monitoring-server]
10.0.1.5
```

## Важные замечания

* Файл по `inventory_path` **перезаписывается**
* Директория для inventory должна существовать заранее
* Для Terragrunt рекомендуется использовать `get_repo_root()`

