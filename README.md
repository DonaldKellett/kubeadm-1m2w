# kubeadm-1m2w

Automated creation of [kubeadm](https://kubernetes.io/docs/reference/setup-tools/kubeadm/) cluster \(1 master, 2 workers\) with [OpenTofu](https://opentofu.org/) and [Ansible](https://www.ansible.com/)

## Developing

Fork and clone this repository, then navigate to the project root and follow the instructions below.

### Install pre-commit hook \(optional\)

The pre-commit hook runs formatting and sanity checks such as `tofu fmt` to reduce the chance of accidentally submitting badly formatted code that would fail CI.

```bash
ln -s ../../hooks/pre-commit ./.git/hooks/pre-commit
```

### Prerequisites

#### OpenTofu

Install the latest version of [OpenTofu](https://opentofu.org/docs/intro/install/portable). The version used is `1.6.0-rc1` at the time of writing \(2023-12-22\).

You'll also need an SSH key pair for remoting into your instances - generate this with `ssh-keygen` if you haven't already.

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
| `region` | `string` | `"ap-east-1"` | AWS region to deploy the resources into |
| `ssh_pubkey_path` | `string` | `"~/.ssh/id_rsa.pub"` | Path to SSH public key. You may assume it is evaluated with `pathexpand()` before use |
| `vpc_cidr` | `string` | `"10.0.0.0/16"` | VPC CIDR block. Should be a valid [RFC 1918](https://datatracker.ietf.org/doc/html/rfc1918) private subnet |
| `subnet_cidr` | `string` | `"10.0.1.0/24"` | Subnet CIDR block. Should be a valid subnet of the VPC CIDR block |

## License

[MIT](./LICENSE)
