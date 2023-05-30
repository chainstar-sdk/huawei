module "security_group" {
  source = "../../security-groups/default"
}

locals {
  resource = yamldecode(file("${path.cwd}/config.yaml")).configs.resources.cce_turbo_cluster.node_pool
}

resource "random_integer" "idx" {
  min = 0
  max = length(var.availability_zone) - 1
}

resource "huaweicloud_cce_node_pool" "node_pool" {
  cluster_id               = var.cce_id
  name                     = local.resource.name
  os                       = local.resource.os
  initial_node_count       = local.resource.initial_node_count
  flavor_id                = local.resource.flavor_id
  availability_zone        = var.availability_zone[random_integer.idx.result]
  min_node_count           = local.resource.min_node_count
  max_node_count           = local.resource.max_node_count
  password                 = "password123"
  security_groups          = [module.security_group.id]
  scall_enable             = local.resource.scall_enable
  scale_down_cooldown_time = local.resource.scale_down_cooldown_time
  priority                 = local.resource.priority
  type                     = local.resource.type

  root_volume {
    size       = local.resource.root_volume.size
    volumetype = local.resource.root_volume.volume_type
  }

  data_volumes {
    size       = local.resource.data_volume.size
    volumetype = local.resource.data_volume.volume_type
  }
}