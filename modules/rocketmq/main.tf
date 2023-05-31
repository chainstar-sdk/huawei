# ECS 自建 500G 硬盘, 六个节点

locals {
  node_count = 6
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

resource "huaweicloud_compute_instance" "this" {
  count              = local.node_count
  name               = "rocketmq_instance_${count.index}"
  image_id           = data.huaweicloud_images_image.rocketmq_image.id
  flavor_id          = data.huaweicloud_compute_flavors.rocketmq_flavor.ids[0]
  security_group_ids = [module.security_group.id]
  availability_zone  = var.availability_zones[count.index % length(var.availability_zones)]

  network {
    uuid = var.subnet_id
  }

  data_disks {
    type = "SAS"
    size = "500"
  }

  delete_disks_on_termination = true
}