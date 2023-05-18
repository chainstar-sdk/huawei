locals {
  db_name = "sample_database"
}

resource "huaweicloud_networking_secgroup" "security-group" {
  name        = local.db_name
  description = "MySQL security group"
}
  
resource "huaweicloud_networking_secgroup_rule" "security-group-r1" {
  security_group_id = huaweicloud_networking_secgroup.security-group.id
  direction      = "ingress"
  ethertype      = "IPv4"
  protocol       = "tcp"
  port_range_min = "3306"
  port_range_max = "3306"
  remote_ip_prefix  = var.vpc_cidr_block
}