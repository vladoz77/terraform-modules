# outputs.tf
output "security_group_name" {
  description = "Name of the created security group"
  value       = yandex_vpc_security_group.sg.name
}

output "security_group_id" {
  description = "ID of the created security group"
  value       = yandex_vpc_security_group.sg.id
}
