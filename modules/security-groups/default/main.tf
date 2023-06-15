resource "huaweicloud_networking_secgroup" "this" {
  name                 = "${var.name}"
  description          = "${var.description}"
}