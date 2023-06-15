## That Redis which uses self-built ECS

# Used 8vcpu 32gb-mem as 4vcpu 32gb-mem not applicable
data "huaweicloud_compute_flavors" "redis_flavor" {
  availability_zone = var.availability_zone
  performance_type  = "normal"
  cpu_core_count    = 8
  memory_size       = 32
}

# Image for redis instances
data "huaweicloud_images_image" "redis_image" {
  name        = "Ubuntu 18.04 server 64bit"
  most_recent = true
}

module "ecs_service" {
  source                   = "../../../huaweicloud/terraform-huaweicloud-ecs"
  subnet_id                = var.subnet_id
  security_group_ids       = var.security_group_id
  availability_zone        = var.availability_zone
  instance_name            = var.name
  instance_flavor_id       = data.huaweicloud_compute_flavors.redis_flavor.ids[0]
  instance_image_id        = data.huaweicloud_images_image.redis_image.id
  system_disk_type         = var.system_disk_type
  system_disk_size         = var.system_disk_size
  admin_password           = "Password1234"
  data_disks_configuration = var.data_disks_configuration
}