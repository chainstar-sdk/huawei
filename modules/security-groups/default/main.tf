resource "huaweicloud_networking_secgroup" "this" {
  name                 = "${var.name}"
  description          = "${var.description}"
  delete_default_rules = false
}

# module "security_group_rules" {
#   source            = "../rules"
#   # count             = var.remote_group_id != null ? 1 : 0
#   security_group_id = resource.huaweicloud_networking_secgroup.this.id
#   rules             = var.remote_group_id != null ? [{
#     remote_group_id = var.remote_group_id
#   }] : []
# }