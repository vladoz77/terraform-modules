variable "groups" {
  type = map(list(string))
  description = "Groups and address for ansible inventory"
  default = {}
}

variable "environment" {
  type = string
  description = "Enviroment for ansible (prod, dev, stage, etc)"
}

variable "ansible_path" {
  type = string
  description = "Path for inventory"
}