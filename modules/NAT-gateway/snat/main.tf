resource "huaweicloud_vpc_bandwidth" "this" {
  name = "snat_eip"
  size = 5
}

resource "huaweicloud_vpc_eip" "this" {
  count = length(var.subnet_ids)
  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type = "WHOLE"
    id         = huaweicloud_vpc_bandwidth.this.id
  }
}

# resource "huaweicloud_nat_snat_rule" "this" {
#   for_each  = toset(var.subnet_ids)
#   nat_gateway_id = var.subnets_nat_gateway[each.key]
#   depends_on = [huaweicloud_vpc_bandwidth.this]
#   floating_ip_id = huaweicloud_vpc_eip.this["#how to get count from huaweicloud_vpc_eip"].id
#   subnet_id      = each.key
# }

resource "huaweicloud_nat_snat_rule" "this" {
  count = length(var.subnet_ids)
  nat_gateway_id = var.subnets_nat_gateway[var.subnet_ids[count.index]]
  depends_on = [huaweicloud_vpc_bandwidth.this]
  floating_ip_id = huaweicloud_vpc_eip.this[count.index].id
  subnet_id      = var.subnet_ids[count.index]
}