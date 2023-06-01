resource "huaweicloud_nat_gateway" "this" {
  name      = "Public NAT gateway"
  vpc_id    = "70ffecf5-ca9f-41dc-b1da-316a33ad9c62" #var.vpc_id
  subnet_id = "7fcb88ff-765f-4f18-a9a7-335d807e8499" #var.subnet_id
  spec      = "3"
}

resource "huaweicloud_vpc_bandwidth" "this" {
  name = "snat_eip"
  size = 5
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