# yc-network/variables.tf
variable "zone" {
  type        = string
  description = "yandex zone"
}

variable "network_name" {
  type        = string
  description = "network name"
}

variable "subnet_name" {
  type        = string
  description = "subnet name"
}

variable "ipv4_cidr" {
  type        = list(string)
  description = "cidr ip"
}

variable "static_address" {
  description = "Static external IPv4 address config. Set to null to skip creation"
  type = object({
    name                = optional(string)
    deletion_protection = optional(bool, false)
  })
  default  = null
  nullable = true
}
