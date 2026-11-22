variable "vpc_cidr" {
  type        = string
  description = "VPC range to carve the subnet ranges from. Try 10.0.0.0/33 to see the validation fail."
  default     = "10.0.0.0/16"

  validation {
    condition     = can(cidrhost(var.vpc_cidr, 0))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block, for example 10.0.0.0/16."
  }
}
