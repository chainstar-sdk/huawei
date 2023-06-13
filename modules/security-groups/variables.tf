variable security_group_name {
  type    = string
  default = null
}

variable description {
  type    = string
  default = "Default security group"
}

variable "rules" {
  type = list(map(string))
  description = "List of rules in a security group"
  default     = []
}