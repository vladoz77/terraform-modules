# main.tf
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.176.0"
    }
  }
  required_version = ">=1.9.8"
}

resource "yandex_vpc_security_group" "sg" {
  name        = var.sg_name
  description = var.sg_description
  network_id  = var.network_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    iterator = item
    content {
      protocol          = try(item.value.protocol, null)
      port              = try(item.value.port, null)
      v4_cidr_blocks    = try(item.value.v4_cidr_blocks, null)
      description       = item.value.description
      from_port         = try(item.value.from_port, null)
      to_port           = try(item.value.to_port, null)
      predefined_target = try(item.value.predefined_target, null)
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    iterator = item
    content {
      protocol          = try(item.value.protocol, null)
      port              = try(item.value.port, null)
      v4_cidr_blocks    = try(item.value.v4_cidr_blocks, null)
      description       = item.value.description
      from_port         = try(item.value.from_port, null)
      to_port           = try(item.value.to_port, null)
      predefined_target = try(item.value.predefined_target, null)
    }
  }
}
