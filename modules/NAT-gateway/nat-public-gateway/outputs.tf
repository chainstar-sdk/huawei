output "subnets_nat_gateway" {
  # key = subnet_id
  # v = gateway_id
  value = {
    for k, v in huaweicloud_nat_gateway.this :
    k => v.id
  }
}