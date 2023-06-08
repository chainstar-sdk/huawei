variable "security_group_id" {
  description = "The ID of the security group"
  default     = ""
}

variable "rules" {
  type = list(map(string))
  description = "List of rules in a security group"
  default     = []
}