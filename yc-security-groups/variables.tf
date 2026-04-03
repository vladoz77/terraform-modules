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

  validation {
    condition = alltrue([
      for rule in values(var.ingress_rules) :
      contains(["ANY","TCP","UDP","ICMP","AH","ESP","GRE"], upper(rule.protocol))
    ])
    error_message = "Protocol must be one of: ANY, TCP, UDP, ICMP, AH, ESP, GRE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in values(var.ingress_rules) : [
        for cidr in try(rule.v4_cidr_blocks, []) :
        can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Each ingress_rules[*].v4_cidr_blocks value must be a valid IPv4 CIDR."
  }
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

  validation {
    condition = alltrue([
      for rule in values(var.egress_rules) :
      contains(["ANY","TCP","UDP","ICMP","AH","ESP","GRE"], upper(rule.protocol))
    ])
    error_message = "Protocol must be one of: ANY, TCP, UDP, ICMP, AH, ESP, GRE."
  }

  validation {
    condition = alltrue(flatten([
      for rule in values(var.egress_rules) : [
        for cidr in try(rule.v4_cidr_blocks, []) :
        can(cidrhost(cidr, 0))
      ]
    ]))
    error_message = "Each egress_rules[*].v4_cidr_blocks value must be a valid IPv4 CIDR."
  }
}
