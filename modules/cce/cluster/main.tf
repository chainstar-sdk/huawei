locals {
  resource = yamldecode(file("${path.cwd}/config.yaml")).configs.resources.cce_turbo_cluster
  subnet  = local.resource.subnet
}

resource "huaweicloud_vpc_subnet" "this" {
  name       = local.resource.subnet.name
  cidr       = local.resource.subnet.cidr
  gateway_ip = local.resource.subnet.gateway_ip
  vpc_id     = var.vpc_id
}

resource "huaweicloud_cce_cluster" "this" {
  name                   = "cluster"
  flavor_id              = "cce.s1.small"
  vpc_id                 = var.vpc_id
  subnet_id              = var.default_subnet_id
  container_network_type = "eni"
  eni_subnet_id          = huaweicloud_vpc_subnet.this.ipv4_subnet_id
  eni_subnet_cidr        = huaweicloud_vpc_subnet.this.cidr
}