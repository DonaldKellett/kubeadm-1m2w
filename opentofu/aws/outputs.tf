output "k8s-master0-public-ip" {
  value = aws_instance.k8s-master0.public_ip
}
