resource "local_file" "ansible-config" {
  content  = <<EOT
[defaults]
inventory = ./hosts.yaml
remote_user = root
private_key_file = ${pathexpand(var.ssh_privkey_path)}
host_key_checking = False
EOT
  filename = "${path.module}/../../ansible/ansible.cfg"
}

resource "local_file" "ansible-hosts" {
  content  = <<EOT
masters:
  hosts:
    master0:
      ansible_host: ${alicloud_instance.k8s-master0.public_ip}
      private_ip: ${alicloud_instance.k8s-master0.private_ip}
workers:
  hosts:
    worker0:
      ansible_host: ${alicloud_instance.k8s-worker0.public_ip}
    worker1:
      ansible_host: ${alicloud_instance.k8s-worker1.public_ip}
EOT
  filename = "${path.module}/../../ansible/hosts.yaml"
}
