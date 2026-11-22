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
