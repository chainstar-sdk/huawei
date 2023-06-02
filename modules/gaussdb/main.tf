data "huaweicloud_gaussdb_mysql_flavors" "flavors" {
  availability_zone_mode = "multi"
}

module "security_group" {
  source = "../security-groups/default"
}

locals {
  resource = yamldecode(file("${path.cwd}/config.yaml")).configs.resources.gaussdb
  flavors  = [ 
    for flavor in data.huaweicloud_gaussdb_mysql_flavors.flavors.flavors: 
      flavor.name
      if flavor.memory == "128" &&
         flavor.vcpus  == "32" &&
         flavor.type   == "x86"
  ]
}

resource "huaweicloud_gaussdb_mysql_instance" "this" {
  name                     = "nb-prod-gauss"
  password                 = "Password!@#$%"
  flavor                   = local.flavors[0]
  vpc_id                   = var.vpc_id
  subnet_id                = var.subnet_id
  security_group_id        = module.security_group.id
  master_availability_zone = local.resource.master_availability_zone
  availability_zone_mode   = local.resource.availability_zone_mode
}