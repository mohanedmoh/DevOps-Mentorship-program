# 01 AWS VPC

Tasks 1, 2, 3 and 5.

## first-instance

The smallest useful Terraform: one EC2 instance. It looks up the current Amazon Linux 2023 image from a public SSM parameter, so there is no image ID to keep up to date.

```bash
cd first-instance
terraform init
terraform apply
terraform destroy
```

## vpc

A VPC with two public and two private subnets, an internet gateway, a NAT gateway and route tables. A bastion sits in a public subnet. A second instance sits in a private subnet and only accepts SSH from the bastion.

You must pass two values. Do not commit them:

```bash
export TF_VAR_admin_cidr="$(curl -s https://checkip.amazonaws.com)/32"
export TF_VAR_public_key="$(cat ~/.ssh/id_ed25519.pub)"
terraform init
terraform plan
terraform apply
```

With the default values the plan adds 24 resources.

Reach the private instance through the bastion:

```bash
ssh-add ~/.ssh/id_ed25519
ssh -A ec2-user@<bastion_public_ip>
ssh ec2-user@<private_instance_ip>
```

`-A` forwards your key agent, so the private key never lands on the bastion.

### Cost

The NAT gateway bills by the hour and by the gigabyte. `single_nat_gateway = true` keeps it to one. Set it to `false` to see one gateway per zone, and what that does to the bill. Destroy at the end of the session.

### Questions to talk through

- Why does the private route table point at the NAT gateway and not at the internet gateway?
- What stops the private instance from being reached from the internet?
- What changes if the one NAT gateway fails? What does the fix cost?
- Why is `ssh -A` safer than copying the private key to the bastion? What is its own risk?
- `count` makes the subnets. What goes wrong if you remove the first CIDR from the list?
