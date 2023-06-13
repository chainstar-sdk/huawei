## That Redis which uses self-built ECS
module "security_group" {
  source = "../../security-groups/default"
}

module "security_group_rules" {
  source          = "../../security-groups/rules"
  security_group_id = module.security_group.id
  rules = [{
    "direction": "ingress",
    "ethertype": "ipv4",
    "protocol": "tcp",
    "ports": "22",
    "remote_group_id": var.remote_group_id
  }]
}

locals {
  nodes_config = {
    "redis_swap" = {
      count = 1
    }
    "redis_spot" = {
      count = 1
    }
  }
}

# Used 8vcpu 32gb-mem as 4vcpu 32gb-mem not applicable
data "huaweicloud_compute_flavors" "redis_flavor" {
  availability_zone = var.availability_zones[0]
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
    source   = "../../../huaweicloud/terraform-huaweicloud-ecs"
  # source   = "git::https://github.com/chainstar-sdk/huawei.git//huaweicloud/terraform-huaweicloud-ecs"
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
  instance_flavor_id       = data.huaweicloud_compute_flavors.redis_flavor.ids[0]
  instance_image_id        = data.huaweicloud_images_image.redis_image.id
  system_disk_type         = "SSD"
  system_disk_size         = 40
  admin_password           = "Password1234"
  data_disks_configuration = [{
    type = "SAS"
    size = "100"
  }]
}