locals {
  resource = yamldecode(file("${path.cwd}/config.yaml")).configs.resources.cce_turbo_cluster
}

resource "huaweicloud_vpc_subnet" "this" {
  name       = "subnet-eni"
  cidr       = local.resource.eni_subnet
  gateway_ip = local.resource.gateway_ip
  vpc_id     = var.vpc_id
}

resource "huaweicloud_cce_cluster" "cce" {
  name                   = "cluster"
  flavor_id              = "cce.s1.small"
  vpc_id                 = var.vpc_id
  subnet_id              = var.default_subnet_id
  container_network_type = "eni"
  eni_subnet_id          = huaweicloud_vpc_subnet.this.ipv4_subnet_id
  eni_subnet_cidr        = huaweicloud_vpc_subnet.this.cidr
}