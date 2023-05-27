resource "huaweicloud_nat_gateway" "nat_public_gateway" {
  name        = "nat_public_gateway"
  spec        = "3"
  vpc_id      = var.vpc_id
  subnet_id   = var.subnet_id
}
