# 16C32G,主备 [sold out]
# Choose 8C32G instead

module "security_group" {
  source = "../security-groups/default"
  name = "${var.instance_name}_SG"
}

module "security_group_rules" {
  source = "../security-groups/rules"
  security_group_id = module.security_group.id
  rules             = var.common_security_rules
}

locals {
  number_of_instance = 1
  availability_zones = tolist(setsubtract(var.availability_zones, ["ap-southeast-3b"]))
}

resource "random_password" "default" {
  length           = 12
  special          = true
  override_special = "_%"
}

resource "huaweicloud_rds_instance" "this" {
  count             = local.number_of_instance
  name              = var.instance_name
  flavor            = data.huaweicloud_rds_flavors.this.flavors[0].name
  vpc_id            = var.vpc_id
  subnet_id         = var.subnet_id
  security_group_id = module.security_group.id
  availability_zone = [local.availability_zones[count.index % length(local.availability_zones)]]

  db {
    type     = "MySQL"
    version  = "8.0"
    password = resource.random_password.default.result
  }

  volume {
    type = "CLOUDSSD"
    size = 40
  }

  backup_strategy {
    start_time = "03:00-04:00" # 03:00-6:00 is not valid
    keep_days  = 1
  }
  # iam_database_authentication_enabled not implemented
  # PERFORMANCE INSIGHTS not implemented
  # DB Subnet group not implemented
  # DB option group not implemented
  # Database Deletion Protection not implemented

# param_group_id = huaweicloud_rds_parametergroup.parameter_group.id
}

# resource "huaweicloud_rds_parametergroup" "parameter_group" {
# name        = "parameter_group"
# description = "RDS parameter group"
# values      = {
# character_set_client = "utf8mb4"
# character_set_server = "utf8mb4"
#   }
#   datastore { # required
# type    = "MySQL" # required
# version = "8.0" # required
#   }
# }

