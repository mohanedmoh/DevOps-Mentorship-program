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

variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version for the control plane. Check the EKS version calendar before you pick one."
  default     = "1.36"
}

variable "node_instance_type" {
  type        = string
  description = "Instance type for the worker nodes."
  default     = "t3.medium"
}

variable "admin_cidr" {
  type        = string
  description = "CIDR allowed to reach the public Kubernetes API endpoint, for example 203.0.113.10/32. Pass it with -var or TF_VAR_admin_cidr."

  validation {
    condition     = can(cidrhost(var.admin_cidr, 0))
    error_message = "admin_cidr must be a valid IPv4 CIDR block, for example 203.0.113.10/32."
  }
}
