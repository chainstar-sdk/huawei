locals {
  security_group_rules = yamldecode(file("${path.cwd}/security_group_configs.yaml")).security_group_rules
  dcs_resources        = yamldecode(file("${path.cwd}/config.yaml")).configs.resources.dcs
  nodepool_resources   = yamldecode(file("${path.cwd}/config.yaml")).configs.resources.cce_turbo_cluster.node_pool
  nodepool_keypair     = yamldecode(file("${path.cwd}/config.yaml")).configs.resources.cce_turbo_cluster.keypair
}

module "vpc" {
  source = "./modules/vpc"
}

module "nat-public-gateway" {
  source     = "./modules/NAT-gateway/nat-public-gateway"
  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.vpc.nat_subnet_ids[0]
  depends_on = [module.vpc]
}

module "snat_rules" {
  source         = "./modules/NAT-gateway/snat"
  subnet_ids     = concat(module.vpc.public_subnet_ids, module.vpc.private_subnet_ids)
  nat_gateway_id = module.nat-public-gateway.nat_gateway_id
  nat_eip_id     = module.nat-public-gateway.nat_eip_id
  depends_on     = [module.nat-public-gateway]
}

module "sg-kubectl" {
  source              = "./modules/security-groups"
  security_group_name = "sg-kubectl-2"
  description         = "security group for kubectl to provision cluster"
  rules               = local.security_group_rules.sg_kubectl
}

module "rds" {
  for_each = {
    "nb-nacos" = {
      vcpus  = "2"
      memory = "4"
    }
    "nb-xxl" = {
      vcpus  = "2"
      memory = "4"
    }
  }
  common_security_rules = [{
    direction      = "ingress",
    ethertype      = "IPv4",
    protocol       = "tcp",
    port_range_min = "3306",
    port_range_max = "3306",
    remote_ip_cidr = "10.10.0.0/21"
  }]
  source             = "./modules/rds"
  instance_name      = each.key
  vcpus              = each.value.vcpus
  memory             = each.value.memory
  vpc_id             = module.vpc.vpc_id
  availability_zones = data.huaweicloud_availability_zones.this.names
  subnet_id          = module.vpc.database_subnet_ids[0]
  depends_on         = [module.vpc]
}

module "cce" {
  source            = "./modules/cce/cluster"
  vpc_id            = module.vpc.vpc_id
  default_subnet_id = module.vpc.private_subnet_ids[0]
  key_pair          = "placeholder_text" # Add own SSH Key
  availability_zone = data.huaweicloud_availability_zones.this.names[0]
  depends_on        = [module.vpc]
}

module "cce_snat_rules" {
  source         = "./modules/NAT-gateway/snat"
  subnet_ids     = [module.cce.eni_subnet_id]
  nat_gateway_id = module.nat-public-gateway.nat_gateway_id
  nat_eip_id     = module.nat-public-gateway.nat_eip_id
  depends_on     = [module.nat-public-gateway, module.cce]
}

module "cce_node_pool_sg" {
  # 49ae5dfb-2b85-40c3-8b51-09ee4bdee499
  source = "./modules/security-groups/default"
  name   = "sg-cce-nodepool"
}

module "cce_node_pool" {
  for_each           = { for v in local.nodepool_resources : v.name => v }
  source             = "./modules/cce/cce-node-pool"
  name               = each.key
  key_pair           = local.nodepool_keypair
  cce_id             = module.cce.id
  availability_zones = slice(data.huaweicloud_availability_zones.this.names, 0, 3)
  os                 = each.value.os
  node_count         = each.value.node_count
  min_node_count     = each.value.min_node_count
  max_node_count     = each.value.max_node_count
  flavor_id          = each.value.flavor_id
  taints             = each.value.taints
  root_volume        = each.value.root_volume
  data_volume        = each.value.data_volume
  depends_on         = [module.cce, module.cce_node_pool_sg]
}

module "gaussdb" {
  source     = "./modules/gaussdb"
  vpc_id     = module.vpc.vpc_id
  subnet_id  = module.vpc.database_subnet_ids[0]
  depends_on = [module.vpc]
}

module "redis_cluster" {
  for_each           = { for v in local.dcs_resources : v.name => v }
  source             = "./modules/redis/cluster"
  name               = each.key
  vpc_id             = module.vpc.vpc_id
  subnet_ids         = module.vpc.private_subnet_ids
  availability_zones = data.huaweicloud_availability_zones.this.names
  whitelists         = each.value.whitelists
  depends_on         = [module.vpc]
}

module "redis_ecs" {
  source             = "./modules/redis/ecs"
  availability_zones = data.huaweicloud_availability_zones.this.names
  subnet_id          = module.vpc.private_subnet_ids[0]
  depends_on         = [module.vpc]
  remote_group_id    = module.sg-kubectl.id
}

module "dds" {
  source            = "./modules/dds"
  vpc_id            = module.vpc.vpc_id
  subnet_id         = module.vpc.database_subnet_ids[0]
  availability_zone = data.huaweicloud_availability_zones.this.names[0]
  depends_on        = [module.vpc]
}

module "rocketmq" {
  source             = "./modules/rocketmq"
  availability_zones = slice(data.huaweicloud_availability_zones.this.names, 0, 3)
  subnet_id          = module.vpc.private_subnet_ids[0]
  depends_on         = [module.vpc]
}

# Kafka have been moved to kubernetes
# module "kafka" {
# source     = "./modules/kafka"
# vpc_id     = module.vpc.vpc_id
# subnet_id  = module.vpc.private_subnet_ids[0]
# depends_on = [module.vpc]
# }
