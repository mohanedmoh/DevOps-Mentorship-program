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

variable "zone_name" {
  type        = string
  description = "Name of an existing Route 53 hosted zone, for example example.com."
}

variable "site_hostname" {
  type        = string
  description = "Full host name of the site, inside the hosted zone, for example blog.example.com."
}

variable "instance_type" {
  type        = string
  description = "Instance type for the WordPress server."
  default     = "t3.small"
}

variable "db_instance_class" {
  type        = string
  description = "Instance class for the MySQL database."
  default     = "db.t3.micro"
}

variable "wordpress_image" {
  type        = string
  description = "WordPress container image. Pin a full version for anything beyond practice."
  default     = "wordpress:6-apache"
}
