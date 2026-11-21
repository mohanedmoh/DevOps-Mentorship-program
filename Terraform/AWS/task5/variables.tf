variable "env_code" {
  type = string
}
variable "public_cidr" {}
variable "private_cidr" {}
variable "admin_cidr" {
  type        = string
  description = "CIDR allowed to SSH to the public instance, for example 203.0.113.10/32. Pass it with -var or TF_VAR_admin_cidr and do not commit it."
}
