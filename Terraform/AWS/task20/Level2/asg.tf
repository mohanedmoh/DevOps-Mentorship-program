resource "aws_security_group" "allow_ssh_private" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = data.terraform_remote_state.level1.outputs.vpc_id

  ingress {
    description     = "http from lb"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.lb_allow_http_public.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.env_code}-allow_ssh-from-VPC"
  }
}
resource "aws_iam_role" "S3_role" {
  name = var.env_code

  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"]
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    tag-key = "tag-value"
  }
}
resource "aws_iam_instance_profile" "main" {
  name = var.env_code
  role = aws_iam_role.S3_role.name
}
module "asg" {
  source = "terraform-aws-modules/autoscaling/aws"

  # Autoscaling group
  name = var.env_code

  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  wait_for_capacity_timeout = 0
  health_check_grace_period = 100
  health_check_type         = "EC2"
  vpc_zone_identifier       = data.terraform_remote_state.level1.outputs.private_subnet
  target_group_arns         = module.elb.target_group_arns
  force_delete              = true

  # Launch template
  launch_template_name        = var.env_code
  launch_template_description = "Launch template example"
  update_default_version      = true
  iam_instance_profile_arn    = aws_iam_instance_profile.main.arn

  image_id        = data.aws_ami.amazonlinux.id
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.allow_ssh_private.id]
  user_data = base64encode(templatefile("${path.module}/userdata.sh",
    {
      db_password = local.db_password,
      host        = "${module.rds.db_instance_endpoint}"
    }
    )
  )


  tags = {
    Environment = var.env_code
  }
}
