data "alicloud_zones" "k8s-zones" {
  available_resource_creation = "VSwitch"
}

data "alicloud_images" "ubuntu" {
  name_regex = "^ubuntu_22_04_x64*"
  owners     = "system"
}
