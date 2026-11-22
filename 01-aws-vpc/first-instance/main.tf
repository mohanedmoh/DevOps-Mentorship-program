# Amazon Linux 2023, resolved from the public SSM parameter so the code
# always picks the current image for the region.
data "aws_ssm_parameter" "al2023" {
  name = "/aws/service/ami-amazon-linux-latest/al2023-ami-kernel-default-x86_64"
}

resource "aws_instance" "app" {
  ami           = data.aws_ssm_parameter.al2023.value
  instance_type = var.instance_type

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "first-instance"
  }
}
