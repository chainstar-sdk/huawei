variable "vpc_id" {
  description = "Security Group for RDS"
}

variable "subnet_id" {
  description = "ID of subnet for RDS" 
}

variable "availability_zones" {
  description = "Availability zones of RDS"
}

variable "vcpus" {
  description = "Number of vcpus"
}

variable "memory" {
  description = "Memory amount" 
}

variable "instance_name" {
  description = "Name of the instance" 
}