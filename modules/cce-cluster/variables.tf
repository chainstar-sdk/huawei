variable "vpc_id" {
  description = "ID of the VPC where the ECC cluster will be deployed"
}

variable "private_subnets" {
  description = "List of private subnet IDs within the VPC"
}

variable "pri_sg_id" {
  description = "Primary security group, default of CCE node pools"
}

variable "node_pool_one_sg_id" {
  description = "Security group of a CCE node pool one"
}

variable "key_pair" {
  description = "Specifies the key pair name when logging in to select the key pair mode. This parameter and password are alternative. Changing this parameter will create a new resource."
}