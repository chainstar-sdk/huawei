output "nat_gateway_id" {
  value = huaweicloud_nat_gateway.this.id
}

output "nat_eip_id" {
  value = huaweicloud_vpc_eip.this.id
}