data "huaweicloud_networking_secgroup" "this" {
  secgroup_id = var.security_group_id
}

# Create Security Group Rule
# Create Security Group Rule
resource "huaweicloud_networking_secgroup_rule" "this" {
  count             = length(var.rules)
  direction         = lookup(var.rules[count.index], "direction")
  ethertype         = lookup(var.rules[count.index], "ethertype")
  protocol          = lookup(var.rules[count.index], "protocol", null)
  ports             = lookup(var.rules[count.index], "ports", null)
  remote_group_id   = lookup(var.rules[count.index], "remote_group_id", null)
  port_range_min    = lookup(var.rules[count.index], "port_range_min", null)
  priority          = lookup(var.rules[count.index], "port_range_min", null) != null ? null : lookup(var.rules[count.index], "priority", 1)
  port_range_max    = lookup(var.rules[count.index], "port_range_max", null)
  remote_ip_prefix  = lookup(var.rules[count.index], "remote_ip_cidr", null)
  security_group_id = var.security_group_id == "" ? join("", data.huaweicloud_networking_secgroup.this.*.id) : var.security_group_id
}
