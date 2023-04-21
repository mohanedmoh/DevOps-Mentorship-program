resource "aws_s3_bucket" "devopsmentor" {
  bucket = "devopsprojectmentor"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
resource "aws_dynamodb_table" "terraform_lock_state" {
  name           = "terraform_lock_state"
  read_capacity  = "1"
  write_capacity = "1"
  billing_mode   = "PROVISIONED"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
