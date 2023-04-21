terraform {
  backend "s3" {
    bucket         = "devopsprojectmentor"
    key            = "level2.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_lock_state"

  }
}
