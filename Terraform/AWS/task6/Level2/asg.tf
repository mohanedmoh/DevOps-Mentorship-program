
resource "aws_launch_configuration" "main" {
  name_prefix     = var.env_code
  image_id        = data.aws_ami.ubuntu.id
  instance_type   = "t1.micro"
  key_name        = "public_ssh"
  security_groups = [aws_security_group.allow_ssh_private.id]
  user_data       = file("userdata.sh")

}
resource "aws_autoscaling_group" "main" {
  name                 = var.env_code
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  target_group_arns    = [aws_lb_target_group.main.arn]
  launch_configuration = aws_launch_configuration.main.name
  vpc_zone_identifier  = data.terraform_remote_state.level1.outputs.private_subnet

  tag {
    key                 = "Name"
    value               = var.env_code
    propagate_at_launch = true
  }
}
