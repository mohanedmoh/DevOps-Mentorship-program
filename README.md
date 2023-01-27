
# DevOps Mentorship Program tasks

## Tools 

1. Terraform
2. AWS
3. Azure
3. Linux
4. GitHub
6. Docker
7. K8s

# Files 
## Terraform/AWS
* Task1 : Create EC2 instance using Terraform is located in aws.tf 
* Task2 : Create VPC infrastracture then create two EC2 one is bastion (public subnet and inside the VPC) and private EC2, then try to access the private through the public ec2 (Hint: ssh -A arrgument) , find the image below:
&nbsp;<div class="row"><img class="col-md-6" src="https://github.com/mohanedmoh/DevOps-Mentorship-program/blob/main/Images/Task1-AWS-%20VPC.png" data-canonical-src="https://github.com/mohanedmoh/DevOps-Mentorship-program/blob/main/Images/Task1-AWS-%20VPC.png" width="400" height="400" /> &nbsp; <img class="col-md-6" src="https://github.com/mohanedmoh/DevOps-Mentorship-program/blob/main/Images/Task1-Bastion.png" data-canonical-src="https://github.com/mohanedmoh/DevOps-Mentorship-program/blob/main/Images/Task1-Bastion.png" width="300" height="250"/></div>
* Task3 : Improve the VPC terraform code with (resource naming (Local, Global), Variable, Count variable to reduce repeating code) 
