# yc-network/main.tf
terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.176.0"
    }
  }
  required_version = ">=1.9.8"
}

resource "yandex_vpc_network" "network" {
  name = var.network_name 
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.subnet_name
  zone           = var.zone  
  v4_cidr_blocks =  var.ipv4_cidr
  network_id     = yandex_vpc_network.network.id  
}

resource "yandex_vpc_address" "addr" {
  count = var.static_address == null ? 0 : 1

  name                = try(var.static_address.name, null)
  deletion_protection = try(var.static_address.deletion_protection, null)

  external_ipv4_address {
    zone_id = var.zone
  }
}
