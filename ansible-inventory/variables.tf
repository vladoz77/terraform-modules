# variables.tf
variable "groups" {
  type = map(list(string))
  description = "Groups and address for ansible inventory"
  default = {}
}


variable "inventory_path" {
  type = string
  description = "Path for inventory"
}