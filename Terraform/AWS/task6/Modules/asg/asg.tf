
resource "aws_launch_configuration" "main" {
  name_prefix          = var.env_code
  image_id             = var.ami
  instance_type        = "t1.micro"
  security_groups      = [aws_security_group.allow_ssh_private.id]
  user_data            = file("${path.module}/userdata.sh")
  iam_instance_profile = aws_iam_instance_profile.main.name

}
resource "aws_autoscaling_group" "main" {
  name                 = var.env_code
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  target_group_arns    = [var.target_group_arn]
  launch_configuration = aws_launch_configuration.main.name
  vpc_zone_identifier  = var.private_subnet

  tag {
    key                 = "Name"
    value               = var.env_code
    propagate_at_launch = true
  }
}
