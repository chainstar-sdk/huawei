# NOT IN USE

variable "vpc_id" {}
variable "subnets_nat_gateway" {}



locals {
    subnet_ids = keys(var.subnets_nat_gateway)
    destination = "0.0.0.0/0"
    routes       = [
    for subnet_id in local.subnet_ids :
    {
      subnet_id = subnet_id
      nexthop   = var.subnets_nat_gateway[subnet_id]
    }
  ]
}

resource "huaweicloud_vpc_route_table" "this" {
  for_each  = toset(local.routes)
  name    = "demo"
  vpc_id  = var.vpc_id
  subnets = local.subnet_ids

  dynamic "route" {
    # for_each = toset(local.routes)

    content {
      destination = local.destination
      type        = "nat"
      nexthop     = route.value.nexthop
    }
  }
}