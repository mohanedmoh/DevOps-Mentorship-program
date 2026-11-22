terraform {
  required_version = ">= 1.11"

  backend "s3" {
    key          = "web-tier/terraform.tfstate"
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
      Task    = "03-web-tier"
    }
  }
}
