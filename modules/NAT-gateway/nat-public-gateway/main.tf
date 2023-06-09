resource "huaweicloud_nat_gateway" "this" {
  name      = "Public-NAT-gateway"
  vpc_id    = var.vpc_id
  subnet_id = var.subnet_id
  spec      = "3"
}

resource "huaweicloud_vpc_bandwidth" "this" {
  name = "snat_eip"
  size = 200
}

resource "huaweicloud_vpc_eip" "this" {
  publicip {
    type = "5_bgp"
  }

  bandwidth {
    share_type = "WHOLE"
    id         = huaweicloud_vpc_bandwidth.this.id
  }
  depends_on     = [huaweicloud_vpc_bandwidth.this]
}