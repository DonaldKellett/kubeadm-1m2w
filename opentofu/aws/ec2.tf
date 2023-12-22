resource "aws_key_pair" "k8s-node-ssh-pubkey" {
  key_name   = "k8s-node-ssh-pubkey"
  public_key = file(pathexpand(var.ssh_pubkey_path))
}

resource "aws_vpc" "k8s-vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "k8s-subnet" {
  vpc_id     = aws_vpc.k8s-vpc.id
  cidr_block = var.subnet_cidr
}
