variable "region" {
  type        = string
  description = "AWS region. It must match the network layer."
  default     = "eu-west-2"
}

variable "env_code" {
  type        = string
  description = "Short name used as a prefix on every resource."
  default     = "mentor"
}

variable "state_bucket" {
  type        = string
  description = "Bucket that holds the network layer state, the same one as in backend.hcl."
}

variable "network_state_key" {
  type        = string
  description = "Key of the network layer state file."
  default     = "network/terraform.tfstate"
}

variable "instance_type" {
  type        = string
  description = "Instance type for the web servers."
  default     = "t3.micro"
}

variable "min_size" {
  type        = number
  description = "Smallest number of web servers."
  default     = 2
}

variable "max_size" {
  type        = number
  description = "Largest number of web servers."
  default     = 4
}

variable "allowed_cidr" {
  type        = string
  description = "CIDR allowed to reach the load balancer on port 80. The default is open to the internet, which is normal for a public web site."
  default     = "0.0.0.0/0"

  validation {
    condition     = can(cidrhost(var.allowed_cidr, 0))
    error_message = "allowed_cidr must be a valid IPv4 CIDR block."
  }
}
