terraform {
  backend "s3" {
    bucket         = "devopsmentor"
    key            = "level2.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_lock_state"

  }
}
