# DevOps Mentorship Course

Twenty tasks that take you from one EC2 instance to a WordPress site on AWS and a Kubernetes cluster. Everything is built with Terraform. Each task is small enough for one session with a mentor, and the whole course works for self-study too.

## How it works

Each task is a goal. You write the code yourself. The folders hold one working answer to compare with, plus questions to talk through. Do not copy the answer first.

The code is checked on every push by GitHub Actions: `terraform fmt`, `terraform init`, `terraform validate` and `helm lint`. The checks do not apply anything to AWS, so a green tick means the code is well formed, not that it has been deployed.

## What you need

- An AWS account with a budget alert set. Several parts cost money while they run: NAT gateways, load balancers, RDS and EKS.
- The AWS CLI, configured with credentials.
- Terraform 1.11 or newer.
- Git.
- For the last folder: `kubectl` and Helm.

Destroy what you build at the end of every session with `terraform destroy`.

## The tasks

1. **First instance.** Launch an EC2 instance with Terraform. [01-aws-vpc/first-instance](01-aws-vpc/first-instance)
2. **VPC and bastion.** Build a VPC with public and private subnets, an internet gateway and a NAT gateway. Reach a private instance through a bastion with `ssh -A`. [01-aws-vpc/vpc](01-aws-vpc/vpc)
3. **Tidy the VPC.** Add variables, locals, naming and `count` so nothing repeats. [01-aws-vpc/vpc](01-aws-vpc/vpc)
4. **Git.** Interactive rebase, amend, rebase onto main and a safe force push. [06-git-rebase](06-git-rebase)
5. **Data sources and outputs.** Look up zones and images instead of typing them in, and export what you need. [01-aws-vpc/vpc](01-aws-vpc/vpc)
6. **User data.** Install a web server at boot and serve a page on port 80. [02-remote-state/app](02-remote-state/app)
7. **Remote state.** Keep state in S3 with native locking. [02-remote-state](02-remote-state)
8. **Layers.** Split the code into a network layer and an app layer that read each other's outputs. [02-remote-state](02-remote-state)
9. **Bootstrap the backend.** Create the state bucket with Terraform too. [02-remote-state/bootstrap](02-remote-state/bootstrap)
10. **Load balancer.** Put an Application Load Balancer in front of the servers. [03-web-tier](03-web-tier)
11. **IAM role.** Attach a role to the instances through an instance profile. [03-web-tier](03-web-tier)
12. **Auto Scaling.** Replace single instances with a launch template and an Auto Scaling group. [03-web-tier](03-web-tier)
13. **Session Manager.** Remove the bastion and connect with Systems Manager. [03-web-tier](03-web-tier)
14. **Modules.** Move the VPC into a local module. [04-modules/local-module](04-modules/local-module)
15. **Domain and HTTPS.** Use Route 53 and an ACM certificate. [05-wordpress](05-wordpress)
16. **RDS and Secrets Manager.** Run MySQL on RDS and keep its password in Secrets Manager. [05-wordpress](05-wordpress)
17. **Functions.** Practise `cidrsubnet`, `lookup`, `merge`, `for` and friends. [04-modules/functions](04-modules/functions)
18. **Community modules.** Replace your VPC with a published module and pin its version. [04-modules/registry-module](04-modules/registry-module)
19. **Kubernetes.** Build an EKS cluster with Terraform and install an application with Helm. [08-eks-helm](08-eks-helm)
20. **Final project.** WordPress on AWS with Docker, RDS, HTTPS and Terraform. Then take it further on Kubernetes. [05-wordpress](05-wordpress) and [08-eks-helm](08-eks-helm)

There is one extra folder, [07-audit](07-audit). It is a checklist and a small script for reviewing any Terraform repository for settings that have aged badly. Use it on your own code when the course is done.

## Running a folder

Most folders follow the same steps:

```bash
cd 01-aws-vpc/vpc
cp terraform.tfvars.example terraform.tfvars   # then edit it
terraform init
terraform plan
terraform apply
terraform destroy
```

Folders that use remote state need the state bucket first. Run `02-remote-state/bootstrap`, copy `02-remote-state/backend.hcl.example` to `backend.hcl`, fill in the bucket name, and start each layer with:

```bash
terraform init -backend-config=../backend.hcl
```

Real `.tfvars` files and `backend.hcl` are ignored by git. Keep account details and addresses out of the repository.

## Layout

```
01-aws-vpc/        tasks 1, 2, 3, 5
02-remote-state/   tasks 6, 7, 8, 9
03-web-tier/       tasks 10, 11, 12, 13
04-modules/        tasks 14, 17, 18
05-wordpress/      tasks 15, 16, 20
06-git-rebase/     task 4
07-audit/          review checklist and scan script
08-eks-helm/       tasks 19, 20
.github/           the checks
```

Lock files (`.terraform.lock.hcl`) are not committed here, because each learner works in their own copy. Commit yours when you start a real project.
