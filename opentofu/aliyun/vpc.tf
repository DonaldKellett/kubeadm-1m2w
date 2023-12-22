resource "alicloud_vpc" "k8s-vpc" {
  vpc_name   = "k8s-vpc"
  cidr_block = var.vpc_cidr
}

resource "alicloud_vswitch" "k8s-vswitch" {
  vswitch_name = "k8s-vswitch"
  cidr_block   = var.vswitch_cidr
  vpc_id       = alicloud_vpc.k8s-vpc.id
  zone_id      = data.alicloud_zones.k8s-zones.zones.0.id
}
