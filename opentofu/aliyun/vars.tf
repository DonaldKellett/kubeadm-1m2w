variable "aliyun_access_key" {
  type = string
}

variable "aliyun_secret_key" {
  type = string
}

variable "region" {
  type    = string
  default = "cn-hongkong"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vswitch_cidr" {
  type    = string
  default = "10.0.1.0/24"
}

variable "instance_type" {
  type    = string
  default = "ecs.g7.large"
}

variable "ssh_privkey_path" {
  type    = string
  default = "~/.ssh/id_rsa"
}

variable "ssh_pubkey_path" {
  type    = string
  default = "~/.ssh/id_rsa.pub"
}

variable "system_disk_size" {
  type    = number
  default = 20
}

variable "data_disk_size" {
  type    = number
  default = 64
}
