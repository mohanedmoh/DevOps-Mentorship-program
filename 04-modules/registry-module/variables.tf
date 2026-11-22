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
