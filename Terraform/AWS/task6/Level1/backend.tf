terraform {
  backend "s3" {
    bucket         = "devopsmentor"
    key            = "level1.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform_lock_state"

  }
}
