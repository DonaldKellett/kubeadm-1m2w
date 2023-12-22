output "k8s-master0-public-ip" {
  value = aws_instance.k8s-master0.public_ip
}

output "k8s-worker0-public-ip" {
  value = aws_instance.k8s-worker0.public_ip
}

output "k8s-worker1-public-ip" {
  value = aws_instance.k8s-worker1.public_ip
}
