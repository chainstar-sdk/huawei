data "huaweicloud_networking_secgroup" "this" {
  secgroup_id = var.security_group_id
}

# Create Security Group Rule
resource "huaweicloud_networking_secgroup_rule" "this" {
  count             = "${length(var.rules)}"
  direction         = "${lookup(var.rules[count.index], "direction")}"
  ethertype         = "${lookup(var.rules[count.index], "ethertype")}"
  protocol          = "${lookup(var.rules[count.index], "protocol")}"
  port_range_min    = "${lookup(var.rules[count.index], "port_range_min")}"
  port_range_max    = "${lookup(var.rules[count.index], "port_range_max")}"
  remote_ip_prefix  = "${lookup(var.rules[count.index], "remote_ip_cidr")}"
  security_group_id = "${var.security_group_id=="" ? join("",data.huaweicloud_networking_secgroup.this.*.id) : var.security_group_id}"
}