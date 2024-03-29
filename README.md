
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
* Task4 : learn more about git commands, and how to solve conflict. bellow is the list of commands we discussed:

                * One: git rebase -i HEAD~7 - interactive rebase of last 7 commits then do git push --force

                          interactive rebase options:
                          1. p, pick <commit> = use commit
                          2. r, reword <commit> = use commit, but edit the commit message
                          3. e, edit <commit> = use commit, but stop for amending
                          4. s, squash <commit> = use commit, but meld into previous commit
                          5. d, drop <commit> = remove commit

                * Two: git commit --amend - instead of adding additional commit, amend the prvious one

                * Three: git rebase main - rebase your main branch, useful when you need to solve merge conflicts
* Task5 : Create two EC2 instance using Terraform and improve the code by using data.tf to get the availablity zones and AMI, and output.tf to export the instance public IP after creation
* Task6 : use userdata to install apache2, clone 2048 game from github and open port 80 to access the game from browser (http)
* Task7 : use remote state to store terraform state on S3 bucket
* Task8 : Create Layers for AWS infrastructure to encapsulate each layer
* Task9 : Automate remote backend by adding new layer to create both S3 bucket and dynamodb 
* Task10 : Create load balancer
* Task11 : attach IAM role to EC2 instance
* Task12 : Create auto scalling group
* Task13 : use AWS SSM (Session Manager) instead of using boston instance
* Task14 : create modules for the main services.
* Task15 : Register domain using Route53 service and add SSL encryption
* Task16 : Create RDS MySQL database and use Amazon Secret Manager to store password
* Task17 : Practice Terraform Functions
* Task18 : Open Source Terraform modules
* Task19 : Build EKS cluster using terraform and Helm 
* Task20 : Final project to deploy WordPress application using AWS, Docker, EKS, Terraform, Helm, GitHub
