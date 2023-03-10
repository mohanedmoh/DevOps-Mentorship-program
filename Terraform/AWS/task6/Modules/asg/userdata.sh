sudo yum update -y
sudo yum install -y httpd git
sudo git clone https://github.com/gabrielecirulli/2048.git
sudo cp -R 2048/* /var/www/html
sudo systemctl enable httpd 
sudo systemctl start httpd