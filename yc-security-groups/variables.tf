# variables.tf
variable "network_id" {
  type        = string
  description = "Network id"
}

variable "sg_name" {
  type        = string
  description = "Name of security group"
}

variable "sg_description" {
  type        = string
  description = "Description of security group"
}

variable "ingress_rules" {
  description = "Ingress rules for security group"
  default     = {}
  type = map(object({
    protocol          = string
    port              = optional(number)
    v4_cidr_blocks    = optional(list(string))
    description       = string
    from_port         = optional(number)
    to_port           = optional(number)
    predefined_target = optional(string)
  }))
}

variable "egress_rules" {
  description = "Egress rules for security group"
  default     = {}
  type = map(object({
    protocol          = string
    port              = optional(number)
    v4_cidr_blocks    = optional(list(string))
    description       = string
    from_port         = optional(number)
    to_port           = optional(number)
    predefined_target = optional(string)
  }))
}
