resource "aws_key_pair" "k8s-node-ssh-pubkey" {
  key_name   = "k8s-node-ssh-pubkey"
  public_key = file(pathexpand(var.ssh_pubkey_path))
}

resource "aws_launch_template" "k8s-node-lt" {
  name          = "k8s-node-lt"
  image_id      = data.aws_ami.ubuntu.image_id
  instance_type = var.instance_type
  key_name      = aws_key_pair.k8s-node-ssh-pubkey.key_name
  network_interfaces {
    associate_public_ip_address = true
    subnet_id                   = aws_subnet.k8s-subnet.id
    security_groups = [
      aws_security_group.k8s-sg.id
    ]
  }
  block_device_mappings {
    device_name = "/dev/sdf"
    ebs {
      volume_size = var.data_volume_size
    }
  }
}

resource "aws_instance" "k8s-master0" {
  launch_template {
    id      = aws_launch_template.k8s-node-lt.id
    version = "$Latest"
  }
  root_block_device {
    volume_size = var.sys_volume_size
  }
  user_data = <<EOT
#!/bin/bash -e

sudo hostnamectl set-hostname master0
EOT
  tags = {
    Name = "k8s-master0"
  }
}

resource "aws_instance" "k8s-worker0" {
  launch_template {
    id      = aws_launch_template.k8s-node-lt.id
    version = "$Latest"
  }
  root_block_device {
    volume_size = var.sys_volume_size
  }
  user_data = <<EOT
#!/bin/bash -e

sudo hostnamectl set-hostname worker0
EOT
  tags = {
    Name = "k8s-worker0"
  }
}

resource "aws_instance" "k8s-worker1" {
  launch_template {
    id      = aws_launch_template.k8s-node-lt.id
    version = "$Latest"
  }
  root_block_device {
    volume_size = var.sys_volume_size
  }
  user_data = <<EOT
#!/bin/bash -e

sudo hostnamectl set-hostname worker1
EOT
  tags = {
    Name = "k8s-worker1"
  }
}
