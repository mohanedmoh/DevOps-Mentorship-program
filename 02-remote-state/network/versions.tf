terraform {
  required_version = ">= 1.11"

  # The bucket and region come from backend.hcl, so no account detail
  # is committed. Locking uses a lock file in the bucket.
  backend "s3" {
    key          = "network/terraform.tfstate"
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
      Task    = "02-network"
    }
  }
}
