# kubeadm-1m2w

Automated creation of [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) cluster \(1 master, 2 workers\) with [OpenTofu](https://opentofu.org/) and [Ansible](https://www.ansible.com/)

## What is this?

This automation stack provisions 3 cloud VM instances in the cloud provider of your choice \(currently only [AWS](https://aws.amazon.com/)\) each with 2 vCPUs, 8 GiB of memory, 16 GiB for the system disk and an additional unpartitioned, unformatted 64GiB data disk, then installs a bare-bones [Kubernetes](https://kubernetes.io/) cluster with `kubeadm` in a 3-node configuration with 1 master node and 2 worker nodes.

_Disclaimer: This project is intended for educational and demonstration purposes and is not suitable for use in a production context._ **Use at your own risk.**

## Developing

Fork and clone this repository, then navigate to the project root and follow the instructions below.

### Install pre-commit hook \(optional\)

The pre-commit hook runs formatting and sanity checks such as `tofu fmt` to reduce the chance of accidentally submitting badly formatted code that would fail CI.

```bash
ln -s ../../hooks/pre-commit ./.git/hooks/pre-commit
```

### Prerequisites

#### AWS

If deploying the resources to AWS, you'll need to install and set up [AWS CLI v2](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) with a valid access key and secret key corresponding to an [IAM administrator account](https://docs.aws.amazon.com/streams/latest/dev/setting-up.html).

#### OpenTofu

Install the latest version of [OpenTofu](https://opentofu.org/docs/intro/install/portable). The version used is `1.6.0-rc1` at the time of writing \(2023-12-22\).

You'll also need an SSH key pair for remoting into your instances - generate this with `ssh-keygen` if you haven't already.

#### Ansible

Install the latest version of [Ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html). The version used is `2.16.2` at the time of writing \(2023-12-22\).

### Deploy

#### OpenTofu

```bash
export CLOUD_PROVIDER="aws"
tofu -chdir="opentofu/${CLOUD_PROVIDER}/" init
tofu -chdir="opentofu/${CLOUD_PROVIDER}/" plan
tofu -chdir="opentofu/${CLOUD_PROVIDER}/" apply
```

The following OpenTofu variables are supported for AWS.

| Variable | Type | Default | Description |
| --- | --- | --- | --- |
| `profile` | `string` | `"default"` | AWS profile to assume for AWS CLI v2 and OpenTofu |
| `region` | `string` | `"ap-east-1"` | AWS region to deploy the resources into |
| `ssh_privkey_path` | `string` | `"~/.ssh/id_rsa"` | Path to SSH private key. Evaluated with `pathexpand()` before use |
| `ssh_pubkey_path` | `string` | `"~/.ssh/id_rsa.pub"` | Path to SSH public key. Evaluated with `pathexpand()` before use |
| `vpc_cidr` | `string` | `"10.0.0.0/16"` | VPC CIDR block. Should be a valid [RFC 1918](https://datatracker.ietf.org/doc/html/rfc1918) private subnet |
| `subnet_cidr` | `string` | `"10.0.1.0/24"` | Subnet CIDR block. Should be a valid subnet of the VPC CIDR block |
| `instance_type` | `string` | `t3.large` | EC2 instance type for each node |
| `sys_volume_size` | `number` | `16` | Size of root volume in GiB |
| `data_volume_size` | `number` | `64` | Size of EBS data volume in GiB |

#### Ansible

```bash
export ANSIBLE_CONFIG="${PWD}/ansible/ansible.cfg"
ansible-playbook "${PWD}/ansible/playbook.yaml"
```

## License

[MIT](./LICENSE)
