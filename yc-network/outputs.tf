output "network_id" {
  value       = yandex_vpc_network.network.id
  description = "Get network_id from our network"
}

output "subnet_id" {
  value       = yandex_vpc_subnet.subnet.id
  description = "Get subnet_id from our network"
}

output "network_cidr" {
  value = try(yandex_vpc_subnet.subnet.v4_cidr_blocks[0], null)
}

output "static_address_id" {
  value       = try(yandex_vpc_address.addr[0].id, null)
  description = "Static address resource ID"
}

output "static_external_ipv4_address" {
  value       = try(yandex_vpc_address.addr[0].external_ipv4_address[0].address, null)
  description = "Static external IPv4 address"
}
