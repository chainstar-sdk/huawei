variable "vpc_id" {
  description = "ID of the VPC where the ECC cluster will be deployed"
}

variable "default_subnet_id" {
  description = "Default subnet which the CCE uses"
}

variable "key_pair" {
  description = "Specifies the key pair name when logging in to select the key pair mode. This parameter and password are alternative. Changing this parameter will create a new resource."
}

variable "availability_zone" {
  description = "Availability zone of the CCE"
}