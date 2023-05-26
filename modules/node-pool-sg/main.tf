resource "huaweicloud_networking_secgroup" "node-pool-sg" {
  name        = "node-pool-s2-xlarge-2"
  description = "Security Group for Node pool"
}
  
# resource "huaweicloud_networking_secgroup_rule" "node-pool-sg-r1" {
#   security_group_id = huaweicloud_networking_secgroup.node-pool-sg.id
#   direction         = "ingress"
#   ethertype         = "IPv4"
#   protocol          = "tcp"
#   port_range_min    = 22
#   port_range_max    = 22
#   remote_ip_prefix  = "10.10.0.0/8"
# }