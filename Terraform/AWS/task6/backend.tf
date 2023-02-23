terraform {
  backend "s3" {
    bucket         = "devopsmentor"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_lock_state"

  }
}
