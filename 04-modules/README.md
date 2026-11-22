# 04 Modules and functions

Tasks 14, 17 and 18.

A module is a folder of Terraform that you call like a function. This folder builds the same VPC three ways so you can compare them.

- `modules/vpc` is a module written for this course. It works out its own subnet ranges with `cidrsubnet`, so you pass a VPC range and a number of zones, not lists of CIDR blocks.
- `local-module` calls it with `source = "../modules/vpc"`.
- `registry-module` calls the community VPC module from the Terraform Registry. Its version is pinned with `~> 6.8`.
- `functions` has no provider and needs no AWS account. It is a practice sheet for Terraform functions.

## Run

```bash
cd local-module        # or registry-module
terraform init
terraform apply
terraform destroy
```

## The functions folder

```bash
cd functions
terraform init
terraform apply
```

With the VPC range `10.0.0.0/16` and eight new bits, the public ranges are `10.0.0.0/24`, `10.0.1.0/24` and `10.0.2.0/24`. The private ranges start at `10.0.100.0/24`. The `instance_type` output is `t3.micro`, because the environment is `dev`. `port` is `80`, because `tonumber("eighty")` fails and `try` falls back. `is_valid` is `false`.

For anything else, open `terraform console` and try each expression by hand.

## Pinning versions

`~> 6.8` accepts 6.8 and any later 6.x release, and refuses 7.0. A major version can rename inputs and break your plan. Without a `version` line, Terraform takes the newest release at the time of `init`.

## Questions to talk through

- What does the root module need to know about the VPC module's insides? What should it not know?
- Compare `modules/vpc` with the registry module. What does the registry module give you for free? What does it hide?
- When is writing your own module the better choice?
- Why do the `functions` outputs need no credentials?
