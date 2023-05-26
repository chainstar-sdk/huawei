data "huaweicloud_gaussdb_mysql_flavors" "flavors" {
  availability_zone_mode = "single"
}

locals {
  
  # tidb proxies

  # Could not find 8vcpu's 16gb mem
  # Used next lowest configuration

  tidb_flavors = [ 
    for flavor in data.huaweicloud_gaussdb_mysql_flavors.flavors.flavors: 
      flavor.name
      # Changed 16gb-mem to 32gb-mem as otherwise not available (8 vCPUs | 32 GB is next lowest)
      if flavor.memory == "32" && flavor.vcpus == "8" && flavor.type == "x86"]

  tikv_flavors = [ 
    for flavor in data.huaweicloud_gaussdb_mysql_flavors.flavors.flavors: 
      flavor.name
      if flavor.memory == "32" && flavor.vcpus == "8" && flavor.type == "x86"]

  tiflash_flavors = [ 
    for flavor in data.huaweicloud_gaussdb_mysql_flavors.flavors.flavors: 
      flavor.name
      if flavor.memory == "32" && flavor.vcpus == "8" && flavor.type == "x86"]
}

# Total memory is meant to be 500GB, but cannot find way to unify the instances to use a single volume storage
# Each instance will need to have its separate volume with separate sizes

# tidb instance

resource "huaweicloud_gaussdb_mysql_instance" "tidb" {
  name              = "tidb"
  password          = "Password!@#$%"
  flavor            = "gaussdb.proxy.4xlarge.x86.4"
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  security_group_id = var.secgroup_id
}

# resource "huaweicloud_gaussdb_mysql_instance" "tikv" {
#   name              = "tikv"
#   password          = "Password!@#$%"
#   flavor = "gaussdb.proxy.2xlarge.x86.4"
#   # flavor            = local.tikv_flavors[0]
#   vpc_id            = var.vpc_id
#   subnet_id         = var.subnet_id
#   security_group_id = var.secgroup_id
# }

# resource "huaweicloud_gaussdb_mysql_instance" "tiflash" {
#   name              = "tiflash"
#   password          = "Password!@#$%"
#   flavor            = local.tiflash_flavors[0]
#   vpc_id            = var.vpc_id
#   subnet_id         = var.subnet_id
#   security_group_id = var.secgroup_id
# }

# tidb proxies

# Tidb proxy (6 nodes)

# resource "huaweicloud_gaussdb_mysql_proxy" "tidb_proxy" {
#   instance_id = huaweicloud_gaussdb_mysql_instance.tidb.id
#   flavor      = "gaussdb.proxy.2xlarge.x86.2"
#   node_num    = 6
# }

# Tikv proxy (9 nodes)

# resource "huaweicloud_gaussdb_mysql_proxy" "tikv_proxy" {
#   instance_id = huaweicloud_gaussdb_mysql_instance.tikv.id
#   flavor      = "gaussdb.proxy.2xlarge.x86.4"
#   node_num    = 9
# }

# TiFlash proxy (1 node)

# resource "huaweicloud_gaussdb_mysql_proxy" "tiflash_proxy" {
#   instance_id = huaweicloud_gaussdb_mysql_instance.tiflash.id
#   flavor      = "gaussdb.proxy.2xlarge.x86.8"
#   node_num    = 1
# }