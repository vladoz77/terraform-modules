variable "platform_id" {
  type        = string
  description = "yandex instance platform id"
  # default = "standard-v1"
}

variable "zone" {
  type        = string
  description = "yandex zone"

}

variable "folder_id" {
  type        = string
  description = "folder id"
}

variable "name" {
  type        = string
  description = "vm name"
  nullable    = true
  default     = "yc-instance"
}

variable "os_name" {
  type        = string
  description = "os name (ubuntu-2004-lts)"
  default     = "ubuntu-2404-lts"
}


variable "core_fraction" {
  type    = number
  default = 20
}

variable "cores" {
  type        = number
  default     = 2
  description = "cpu core for vm"
}

variable "memory" {
  type        = number
  default     = 2
  description = "memory for vm"
}


variable "ssh" {
  type        = string
  description = "ssh key for connect to instance"
  nullable    = true
}

variable "tags" {
  type        = list(string)
  description = "tags for vm"
  nullable    = true
  default     = []
}

variable "network_interfaces" {
  type = list(object({
    subnet_id      = string
    nat            = bool
    nat_ip_address = optional(string)
    ip_address     = optional(string)
    security_group = optional(set(string))
  }))
  description = "List of network interfaces for the VM."
  default = [{
    nat_ip_address = null
    subnet_id      = null
    nat            = true
    ip_address     = null
    security_group = null
  }]
}

variable "boot_disk" {
  type = object({
    type = string
    size = number
  })
}

variable "additional_disks" {
  nullable = true
  type = list(object({
    size = number
    type = string # Тип диска (network-hdd, network-ssd, network-ssd-nonreplicated)
  }))
  description = "add additional disk for vm"
  default     = []
}

variable "labels" {
  type     = map(string)
  nullable = true
  default  = {}
}

variable "cloud_init" {
  description = "YAML content for cloud-init configuration"
  type        = string
  default     = null
  sensitive   = false
  nullable    = true
}

variable "create_dns_record" {
  type        = bool
  description = "Create DNS record for instance"
  default     = false
}

variable "dns_zone_name" {
  type        = string
  description = "dns zone name"
  default     = ""
}

variable "dns_records" {
  type = map(object({
    name = string
    ttl  = number
    type = string
  }))
  default     = {}
  description = "dns record config"
}

variable "wait_timeout" {
  description = "Timeout in seconds to wait for instance to become available via SSH"
  type        = number
  default     = 300
}