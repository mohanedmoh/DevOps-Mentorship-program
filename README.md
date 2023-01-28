
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

                      * One: git rebase -i HEAD~7 - interactive rebase of last 7 commits

                                interactive rebase options:
                                1. p, pick <commit> = use commit
                                2. r, reword <commit> = use commit, but edit the commit message
                                3. e, edit <commit> = use commit, but stop for amending
                                4. s, squash <commit> = use commit, but meld into previous commit
                                5. d, drop <commit> = remove commit

                      * Two: git commit --amend - instead of adding additional commit, amend the prvious one

                      * Three: git rebase main - rebase your main branch, useful when you need to solve merge conflicts
