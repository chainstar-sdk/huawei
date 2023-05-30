variable "vpc_id" {
  description = "ID of the VPC for the NAT public gateway"
}

variable "subnet_ids" {
  type = list(string)
}