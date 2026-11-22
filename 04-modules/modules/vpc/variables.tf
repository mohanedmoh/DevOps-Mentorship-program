variable "name" {
  type        = string
  description = "Prefix for the Name tag of every resource."
}

variable "cidr" {
  type        = string
  description = "CIDR block of the VPC."
  default     = "10.0.0.0/16"
}

variable "az_count" {
  type        = number
  description = "How many availability zones to spread subnets across."
  default     = 2

  validation {
    condition     = var.az_count >= 1 && var.az_count <= 6
    error_message = "az_count must be between 1 and 6."
  }
}

variable "single_nat_gateway" {
  type        = bool
  description = "Use one NAT gateway for every private subnet. Cheaper. Set to false for one per availability zone."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Extra tags to add to every resource."
  default     = {}
}
