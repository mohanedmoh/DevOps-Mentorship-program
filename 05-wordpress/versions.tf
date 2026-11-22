terraform {
  required_version = ">= 1.11"

  backend "s3" {
    key          = "wordpress/terraform.tfstate"
    use_lockfile = true
    encrypt      = true
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Project = "devops-mentorship"
      Task    = "05-wordpress"
    }
  }
}
