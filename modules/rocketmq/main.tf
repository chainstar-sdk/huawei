# ECS 自建 500G 硬盘, 六个节点

locals {
  nodes_config = {
    "rocketmq_swap" = {
      count = 3
    }
    "rocketmq_spot" = {
      count = 3
    }
  }
}

module "security_group" {
  source = "../security-groups/default"
}

resource "random_integer" "idx" {
  min = 0
  max = length(var.availability_zones) - 1
}

# Flavor for rocketmq instances
data "huaweicloud_compute_flavors" "rocketmq_flavor" {
  availability_zone = var.availability_zones[0]
  performance_type  = "normal"
  cpu_core_count    = 16
  memory_size       = 32
}

# Image for rocketmq instances
data "huaweicloud_images_image" "rocketmq_image" {
  name        = "Ubuntu 18.04 server 64bit"
  most_recent = true
}

module "ecs_service" {
  source   = "../../huaweicloud/terraform-huaweicloud-ecs"
  for_each = { for item in flatten([
    for key, config in local.nodes_config : [
      for i in range(config.count) : {
        name  = "${key}-${i}"
        index = i
      }
    ]
  ]) : item.name => { index = item.index } }

  subnet_id          = var.subnet_id
  security_group_ids = [module.security_group.id]
  availability_zone  = var.availability_zones[each.value.index % length(var.availability_zones)]

  instance_name            = each.key
  instance_flavor_id       = data.huaweicloud_compute_flavors.rocketmq_flavor.ids[0]
  instance_image_id        = data.huaweicloud_images_image.rocketmq_image.id
  system_disk_type         = "SSD"
  system_disk_size         = 40
  admin_password           = "Password1234"
  data_disks_configuration = [{
    type = "SAS"
    size = "500"
  }]
}