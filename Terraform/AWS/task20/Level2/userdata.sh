#!/bin/bash 

export DB_PASSWORD=${db_password}

sudo yum update -y
sudo yum install docker -y
sudo systemctl start docker
docker run --name wp -p 80:80 -d -e WORDPRESS_DB_HOST=${host} -e WORDPRESS_DB_USER=admin -e WORDPRESS_DB_PASSWORD=${db_password} -e WORDPRESS_DB_NAME=mydb wordpress
