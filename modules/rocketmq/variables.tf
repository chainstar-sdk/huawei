variable "availability_zones" {
  description = "Availiability Zones"
  type = list(string)
}

variable "subnet_id" {
  description = "ID of the VPC's subnet"
}