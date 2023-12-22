resource "alicloud_security_group" "k8s-sg" {
  name   = "k8s-sg"
  vpc_id = alicloud_vpc.k8s-vpc.id
}

resource "alicloud_security_group_rule" "k8s-sg-ingress" {
  type              = "ingress"
  ip_protocol       = "tcp"
  port_range        = "22/22"
  security_group_id = alicloud_security_group.k8s-sg.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_security_group_rule" "k8s-sg-egress" {
  type              = "egress"
  ip_protocol       = "all"
  port_range        = "-1/-1"
  security_group_id = alicloud_security_group.k8s-sg.id
  cidr_ip           = "0.0.0.0/0"
}

resource "alicloud_ecs_key_pair" "k8s-node-ssh-pubkey" {
  key_pair_name = "k8s-node-ssh-pubkey"
  public_key    = file(pathexpand(var.ssh_pubkey_path))
}

resource "alicloud_ecs_launch_template" "k8s-node-lt" {
  launch_template_name          = "k8s-node-lt"
  image_id                      = data.alicloud_images.ubuntu.images.0.id
  instance_charge_type          = "PostPaid"
  instance_type                 = var.instance_type
  key_pair_name                 = alicloud_ecs_key_pair.k8s-node-ssh-pubkey.key_pair_name
  security_enhancement_strategy = "Active"
  security_group_ids            = [alicloud_security_group.k8s-sg.id]

  vswitch_id = alicloud_vswitch.k8s-vswitch.id
  vpc_id     = alicloud_vpc.k8s-vpc.id
  zone_id    = data.alicloud_zones.k8s-zones.zones.0.id

  network_interfaces {
    security_group_id = alicloud_security_group.k8s-sg.id
    vswitch_id        = alicloud_vswitch.k8s-vswitch.id
  }
}

resource "alicloud_instance" "k8s-master0" {
  instance_name      = "k8s-master0"
  launch_template_id = alicloud_ecs_launch_template.k8s-node-lt.id
  host_name          = "master0"

  internet_charge_type       = "PayByBandwidth"
  internet_max_bandwidth_out = 5

  system_disk_size     = tostring(var.system_disk_size)
  system_disk_category = "cloud_essd"

  data_disks {
    delete_with_instance = "true"
    size                 = tostring(var.data_disk_size)
    category             = "cloud_essd"
  }
}

resource "alicloud_instance" "k8s-worker0" {
  instance_name      = "k8s-worker0"
  launch_template_id = alicloud_ecs_launch_template.k8s-node-lt.id
  host_name          = "worker0"

  internet_charge_type       = "PayByBandwidth"
  internet_max_bandwidth_out = 5

  system_disk_size     = tostring(var.system_disk_size)
  system_disk_category = "cloud_essd"

  data_disks {
    delete_with_instance = "true"
    size                 = tostring(var.data_disk_size)
    category             = "cloud_essd"
  }
}

resource "alicloud_instance" "k8s-worker1" {
  instance_name      = "k8s-worker1"
  launch_template_id = alicloud_ecs_launch_template.k8s-node-lt.id
  host_name          = "worker1"

  internet_charge_type       = "PayByBandwidth"
  internet_max_bandwidth_out = 5

  system_disk_size     = tostring(var.system_disk_size)
  system_disk_category = "cloud_essd"

  data_disks {
    delete_with_instance = "true"
    size                 = tostring(var.data_disk_size)
    category             = "cloud_essd"
  }
}
