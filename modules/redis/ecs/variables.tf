variable "availability_zone" {
  description = "AZ of redis-ecs"
}

variable "subnet_id" {
  description = "ID of the VPC's subnet for redis-ecs"
}

variable "name" {}
variable "security_group_id" {}
variable "system_disk_size" {}
variable "system_disk_type" {}
variable "data_disks_configuration" {
  type = list(object({
    type = string
    size = string
  }))
}