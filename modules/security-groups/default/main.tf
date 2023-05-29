resource "huaweicloud_networking_secgroup" "this" {
  name                 = "default_secgroup"
  description          = "Default security group"
  delete_default_rules = false
}