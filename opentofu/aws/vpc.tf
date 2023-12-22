resource "aws_vpc" "k8s-vpc" {
  cidr_block = var.vpc_cidr
}

resource "aws_subnet" "k8s-subnet" {
  vpc_id     = aws_vpc.k8s-vpc.id
  cidr_block = var.subnet_cidr
}

resource "aws_internet_gateway" "k8s-igw" {
  vpc_id = aws_vpc.k8s-vpc.id
}

resource "aws_route_table" "k8s-rtb" {
  vpc_id = aws_vpc.k8s-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.k8s-igw.id
  }
}

resource "aws_route_table_association" "k8s-rtb-association" {
  subnet_id      = aws_subnet.k8s-subnet.id
  route_table_id = aws_route_table.k8s-rtb.id
}

resource "aws_security_group" "k8s-sg" {
  name        = "k8s-sg"
  description = "K8s security group"
  vpc_id      = aws_vpc.k8s-vpc.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
