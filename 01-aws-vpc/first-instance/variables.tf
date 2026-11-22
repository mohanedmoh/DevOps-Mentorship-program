variable "region" {
  type        = string
  description = "AWS region to deploy into."
  default     = "eu-west-2"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
  default     = "t3.micro"
}
