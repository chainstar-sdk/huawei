variable "availability_zones" {
  description = "AZ of redis-ecs"
}

variable "subnet_id" {
  description = "ID of the VPC's subnet for redis-ecs"
}

variable "remote_group_id" {}