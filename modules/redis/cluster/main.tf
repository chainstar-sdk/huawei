data "huaweicloud_dcs_flavors" "single_flavors" {
  cache_mode = "ha"
  capacity   = 4
}

resource "huaweicloud_dcs_instance" "this" {
  name               = var.name
  engine             = "Redis"
  engine_version     = "5.0"
  capacity           = data.huaweicloud_dcs_flavors.single_flavors.capacity
  flavor             = data.huaweicloud_dcs_flavors.single_flavors.flavors[0].name
  availability_zones = [var.availability_zones[0], var.availability_zones[1]]
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_ids[0]

  charging_mode = "postPaid"

  backup_policy {
    backup_type = "auto"
    save_days   = 3
    backup_at   = [1, 3, 5, 7]
    begin_at    = "02:00-04:00"
  }

  dynamic "whitelists" {
    for_each = var.whitelists
    content {
      group_name = whitelists.value["group_name"]
      ip_address = whitelists.value["ip_address"]
    }
  }
}