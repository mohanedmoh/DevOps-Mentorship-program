sudo apt update
sudo apt -y install apache2
cd /var/www/html/
sudo git clone https://github.com/gabrielecirulli/2048
sudo cp -R 2048/* ./
sudo service apache2 restart

