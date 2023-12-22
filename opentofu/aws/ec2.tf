resource "aws_key_pair" "k8s-node-ssh-pubkey" {
  key_name   = "k8s-node-ssh-pubkey"
  public_key = file(pathexpand(var.ssh_pubkey_path))
}

resource "aws_instance" "k8s-master0" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  associate_public_ip_address = true
  key_name                    = aws_key_pair.k8s-node-ssh-pubkey.key_name
  subnet_id                   = aws_subnet.k8s-subnet.id
  vpc_security_group_ids = [
    aws_security_group.k8s-sg.id
  ]
  root_block_device {
    volume_size = var.sys_volume_size
  }
  tags = {
    Name = "k8s-master0"
  }
}
