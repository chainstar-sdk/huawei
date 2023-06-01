resource "huaweicloud_nat_snat_rule" "this" {
  count          = length(var.subnet_ids)
  nat_gateway_id = var.nat_gateway_id
  floating_ip_id = var.nat_eip_id
  subnet_id      = var.subnet_ids[count.index]
}