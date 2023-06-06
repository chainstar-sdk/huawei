module "security_group" {
  source = "../security-groups/default"
}

# 3 副本,DMS 16vCPU, 32G
data "huaweicloud_dms_kafka_flavors" "query_results" {
}

locals {
  resource = yamldecode(file("${path.cwd}/config.yaml")).configs.resources.kafka

  query_results = data.huaweicloud_dms_kafka_flavors.query_results
  flavor_16u32g = [
    for flavor in local.query_results.flavors: 
      flavor 
    if can(regex("16u32g", flavor.id))][0]
}

# place all the dynamic variables into a tfvar file
# do something for the flavor query -> parse through name

# Each instance has min 3 nodes
resource "huaweicloud_dms_kafka_instance" "kafka" {
  name              = "kafka"
  vpc_id            = var.vpc_id
  network_id        = var.subnet_id
  security_group_id = module.security_group.id

  flavor_id          = local.flavor_16u32g.id
  storage_spec_code  = local.flavor_16u32g.ios[0].storage_spec_code
  availability_zones = [local.flavor_16u32g.ios[0].availability_zones[0]]
  engine_version     = element(local.query_results.versions, length(local.query_results.versions)-1)
  storage_space      = local.flavor_16u32g.properties[0].min_broker * local.flavor_16u32g.properties[0].min_storage_per_node
  broker_num         = local.flavor_16u32g.properties[0].min_broker

  access_user = local.resource.access_user
  password    = local.resource.password

  manager_user     = local.resource.manager_user
  manager_password = local.resource.manager_password

  dynamic "cross_vpc_accesses" {
    for_each = local.resource.advertised_ips
    content {
      advertised_ip = cross_vpc_accesses.value
    }
  }
}