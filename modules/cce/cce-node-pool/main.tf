module "security_group" {
  source = "../../security-groups/default"
}

locals {
  resource = yamldecode(file("${path.cwd}/config.yaml")).configs.resources.cce_turbo_cluster.node_pool
}

resource "huaweicloud_kps_keypair" "mykp" {
  name       = "mykp"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAjpC1hwiOCCmKEWxJ4qzTTsJbKzndLo1BCz5PcwtUnflmU+gHJtWMZKpuEGVi29h0A/+ydKek1O18k10Ff+4tyFjiHDQAT9+OfgWf7+b1yK+qDip3X1C0UPMbwHlTfSGWLGZquwhvEFx9k3h/M+VtMvwR1lJ9LUyTAImnNjWG7TAIPmui30HvM2UiFEmqkr4ijq45MyX2+fLIePLRIFuu1p4whjHAQYufqyno3BS48icQb4p6iVEZPo4AE2o9oIyQvj2mx4dk5Y8CgSETOZTYDOR3rU2fZTRDRgPJDH9FWvQjF5tA0p3d9CoWWd2s6GKKbfoUIi8R/Db1BSPJwkqB jrp-hp-pc"
}

resource "huaweicloud_cce_node_pool" "node_pool" {
  cluster_id        = var.cce_id
  name              = local.resource.name
  os                = local.resource.os
  flavor_id         = local.resource.flavor_id #flavor_lookup[var.availability_zones[count.index % length(var.availability_zones)]]
  # availability_zone = var.availability_zones[count.index % length(var.availability_zones)]
  key_pair          = huaweicloud_kps_keypair.mykp.name
  initial_node_count       = local.resource.node_count
  scall_enable             = true
  min_node_count           = local.resource.min_node_count
  max_node_count           = local.resource.max_node_count
  scale_down_cooldown_time = 100
  priority                 = 1
  type                     = "vm"

  root_volume {
    size       = local.resource.root_volume.size
    volumetype = local.resource.root_volume.volume_type
  }

  data_volumes {
    size       = local.resource.data_volume.size
    volumetype = local.resource.data_volume.volume_type
  }
}