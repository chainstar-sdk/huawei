resource "huaweicloud_vpc_subnet" "mysubnet" {
  name       = "subnet"
  cidr       = "10.0.211.0/24"
  gateway_ip = "10.0.211.1"

  //dns is required for cce node installing
  primary_dns   = "100.125.1.250"
  secondary_dns = "100.125.21.250"
  vpc_id        = var.vpc_id
}

resource "huaweicloud_vpc_subnet" "eni_test" {
  name          = "subnet-eni"
  cidr          = "10.0.212.0/24"
  gateway_ip    = "10.0.212.1"
  vpc_id        = var.vpc_id
}

resource "huaweicloud_cce_cluster" "test" {
  name                   = "cluster"
  flavor_id              = "cce.s1.small"
  vpc_id                 = var.vpc_id
  subnet_id              = huaweicloud_vpc_subnet.mysubnet.id
  container_network_type = "eni"
  eni_subnet_id          = huaweicloud_vpc_subnet.eni_test.ipv4_subnet_id
  eni_subnet_cidr        = huaweicloud_vpc_subnet.eni_test.cidr
}