# 16C32G,主备 [sold out]
# Choose 8C32G instead

module "security_group" {
  source = "../security-groups/default"
}

locals {
  number_of_instance = 2
  availability_zones = tolist(setsubtract(var.availability_zones, ["ap-southeast-3b"]))
}

data "huaweicloud_rds_flavors" "this" {
  db_type           = "MySQL"
  db_version        = "8.0"
  instance_mode     = "single"
  vcpus             = "2"
  memory            = "4"
  group_type        = "general"
  availability_zone = var.availability_zones[0]

}

resource "huaweicloud_rds_instance" "this" {
  count               = local.number_of_instance
  name                = "nb-prod-${count.index}"
  flavor              = data.huaweicloud_rds_flavors.this.flavors[0].name # required
  vpc_id              = var.vpc_id
  subnet_id           = var.subnet_id
  security_group_id   = module.security_group.id
  availability_zone   = [local.availability_zones[count.index % length(local.availability_zones)]]

  db {
    type     = "MySQL"
    version  = "8.0"
    password = "Huangwei!120521"
  }

  volume {
    type = "CLOUDSSD"
    size = 40
  }

  backup_strategy {
    start_time = "03:00-04:00" # required; 03:00-6:00 is not valid, so 3:00-4:00
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

