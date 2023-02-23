data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
data "aws_availability_zones" "available" {
  state = "available"
}
data "terraform_remote_state" "level1" {
  backend = "s3"
  config = {
    bucket = "devopsmentor"
    key    = "level1.tfstate"
    region = "us-east-1"
  }
}