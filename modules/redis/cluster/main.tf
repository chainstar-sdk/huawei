data "huaweicloud_dcs_flavors" "single_flavors" {
  cache_mode = "ha"
  capacity   = 4
}

resource "huaweicloud_dcs_instance" "this" {
  name               = "redis"
  engine             = "Redis"
  engine_version     = "5.0"
  capacity           = data.huaweicloud_dcs_flavors.single_flavors.capacity
  flavor             = data.huaweicloud_dcs_flavors.single_flavors.flavors[0].name
  availability_zones = [var.availability_zones[0], var.availability_zones[1]]
  password           = "P@ssword1234!"
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_ids[0]

  charging_mode = "postPaid"

  backup_policy {
    backup_type = "auto"
    save_days   = 3
    backup_at   = [1, 3, 5, 7]
    begin_at    = "02:00-04:00"
  }

  whitelists {
    group_name = "test-group1"
    ip_address = ["192.168.10.100", "192.168.0.0/24"]
  }
  whitelists {
    group_name = "test-group2"
    ip_address = ["172.16.10.100", "172.16.0.0/24"]
  }
}