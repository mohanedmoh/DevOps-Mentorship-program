output "vpc_id" {
  description = "ID of the VPC."
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets."
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets."
  value       = aws_subnet.private[*].id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion."
  value       = aws_instance.bastion.public_ip
}

output "private_instance_ip" {
  description = "Private IP address of the instance in the private subnet."
  value       = aws_instance.private.private_ip
}

output "ssh_command" {
  description = "Connect to the bastion with agent forwarding, then run ssh to the private IP from there."
  value       = "ssh -A ec2-user@${aws_instance.bastion.public_ip}"
}
