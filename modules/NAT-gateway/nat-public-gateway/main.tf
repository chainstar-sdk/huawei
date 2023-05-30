resource "huaweicloud_nat_gateway" "this" {
  for_each  = toset(var.subnet_ids)
  name      = each.key
  vpc_id    = var.vpc_id
  spec      = 3
  subnet_id = each.key
}