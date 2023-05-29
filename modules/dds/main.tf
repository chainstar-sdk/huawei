# REPLICA SET 3节点，DDS for MONGODB

locals {
  resource = yamldecode(file("${path.cwd}/config.yaml")).configs.resources.dds
}

module "security_group" {
  source = "../security-groups/default"
}

resource "huaweicloud_dds_instance" "this" {
  name = "mongodb"
  datastore {
    type           = local.resource.datastore.type
    version        = local.resource.datastore.version
    storage_engine = local.resource.datastore.storage_engine
  }

  # set to Singapore, can change if needed
  availability_zone = var.availability_zone
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  security_group_id = module.security_group.id
  password          = "Test@123!@#"
  mode              = local.resource.mode
  
  dynamic "flavor" {
    for_each = [local.resource.flavor]
    content {
      type      = flavor.value.type
      num       = flavor.value.num
      storage   = flavor.value.storage
      size      = flavor.value.size
      spec_code = flavor.value.spec_code
    }
  }


#  flavor {
#     type      = local.resource.flavor.type
#     num       = local.resource.flavor.num
#     storage   = local.resource.flavor.storage
#     size      = local.resource.flavor.size
#     spec_code = local.resource.flavor.spec_code
#   }
}