resource "huaweicloud_nat_private_gateway" "nat_private_gateway" {
  name                  = "nat_private_gateway"
  spec                  = "Small"
  subnet_id             = var.subnet_id
}
