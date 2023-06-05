data "huaweicloud_rds_flavors" "this" {
  db_type           = "MySQL"
  db_version        = "8.0"
  instance_mode     = "single"
  vcpus             = var.vcpus
  memory            = var.memory
  group_type        = "general"
  availability_zone = var.availability_zones[0]
}