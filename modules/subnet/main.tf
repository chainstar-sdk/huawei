data "huaweicloud_availability_zones" "available" {}

resource "huaweicloud_vpc_subnet" "az1-hasync" {
  vpc_id      = var.vpc_id
  name        = "NB-Production-ap-northeast-1a-hasync"
  cidr  = "10.10.30.0/24"
  gateway_ip  = "10.10.30.1" // Required for huawei
  availability_zone = data.huaweicloud_availability_zones.available.names[0]
}

resource "huaweicloud_vpc_subnet" "az1-hamgmt" {
  vpc_id      = var.vpc_id
  name        = "NB-Production-ap-northeast-1a-hamgmt"
  cidr  = "10.10.31.0/24"
  gateway_ip  = "10.10.31.1" // Required for huawei
  availability_zone = data.huaweicloud_availability_zones.available.names[0]
}

resource "huaweicloud_vpc_subnet" "az2-hasync" {
  vpc_id      = var.vpc_id
  name        = "NB-Production-ap-northeast-1b-hasync"
  cidr        = "10.10.40.0/24"
  gateway_ip  = "10.10.40.1" // Required for huawei
  availability_zone = data.huaweicloud_availability_zones.available.names[1]
}

resource "huaweicloud_vpc_subnet" "az2-hamgmt" {
  vpc_id      = var.vpc_id
  name        = "NB-Production-ap-northeast-1b-hamgmt"
  cidr  = "10.10.41.0/24"
  gateway_ip  = "10.10.41.1" // Required for huawei
  availability_zone = data.huaweicloud_availability_zones.available.names[1]
}