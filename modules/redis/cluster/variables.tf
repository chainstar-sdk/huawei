variable "name" {
  description = "Name"
  type        = string
}

variable "vpc_id" {
    description = "The ID of the VPC"
}

variable "subnet_ids" {
    description = "Subnet IDS"
}

variable "availability_zones" {
  description = "AZs"
}

variable "whitelists" {
  description = "Whitelists"
  type  = list(object({
    group_name = string
    ip_address = list(string)
  }))
}