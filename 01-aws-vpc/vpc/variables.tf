variable "region" {
  type        = string
  description = "AWS region to deploy into."
  default     = "eu-west-2"
}

variable "env_code" {
  type        = string
  description = "Short name used as a prefix on every resource."
  default     = "mentor"
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block of the VPC."
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block, for example 10.0.0.0/16."
  }
}

variable "public_cidrs" {
  type        = list(string)
  description = "One CIDR block per public subnet. Each one goes in a different availability zone."
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_cidrs" {
  type        = list(string)
  description = "One CIDR block per private subnet. Each one goes in a different availability zone."
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use one NAT gateway for every private subnet. Cheaper. Set to false for one per availability zone."
  default     = true
}

variable "instance_type" {
  type        = string
  description = "Instance type for the bastion and the private instance."
  default     = "t3.micro"
}

variable "admin_cidr" {
  type        = string
  description = "CIDR allowed to SSH to the bastion, for example 203.0.113.10/32. Pass it with -var or TF_VAR_admin_cidr and do not commit it."

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0))
    error_message = "admin_cidr must be a valid IPv4 CIDR block, for example 203.0.113.10/32."
  }
}

variable "public_key" {
  type        = string
  description = "Contents of your SSH public key, for example the output of cat ~/.ssh/id_ed25519.pub."
}
