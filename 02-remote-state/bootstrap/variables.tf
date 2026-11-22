variable "region" {
  type        = string
  description = "AWS region for the state bucket."
  default     = "eu-west-2"
}

variable "bucket_name" {
  type        = string
  description = "Name of the state bucket. S3 bucket names are global, so make it unique, for example mentor-tfstate-123456789012."

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name))
    error_message = "bucket_name must be 3 to 63 characters of lower case letters, numbers, dots and hyphens."
  }
}
