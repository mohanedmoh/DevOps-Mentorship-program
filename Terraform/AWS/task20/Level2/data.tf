data "aws_ami" "amazonlinux" {
  most_recent = true


  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20230119.1-x86_64-gp2"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["137112412989"]
}
data "aws_availability_zones" "available" {
  state = "available"
}
data "terraform_remote_state" "level1" {
  backend = "s3"
  config = {
    bucket = "devopsprojectmentor"
    key    = "level1.tfstate"
    region = "us-east-1"
  }
}
