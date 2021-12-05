#set hostname to wills-hub01

hostnamectl set-hostname wills-hub01

#set time zone to Europe/London

timedatectl set-timezone 'Europe/London'

#Check the Time

date

#update system

sudo dnf -y clean all

sudo dnf -y update

yes Y | sudo dnf update

#install nginx

sudo dnf -y install nginx

sudo systemctl enable nginx

sudo systemctl start nginx


#Configure FirewallD

sudo firewall-cmd --zone=public --list-services

sudo firewall-cmd --zone=public --add-service=http --permanent

sudo firewall-cmd --zone=public --add-service=https --permanent

sudo firewall-cmd --reload

#install php

#Install Remi Repository

sudo dnf -y install http://rpms.remirepo.net/enterprise/remi-release-8.rpm

sudo dnf -y install dnf-utils

sudo dnf module list php

sudo dnf -y module reset php

sudo dnf -y module install php:remi-8.0

sudo dnf -y install php

php -v

#install php

sudo dnf -y install php-fpm

sudo systemctl enable php-fpm.service

sudo systemctl start php-fpm.service

sudo dnf install php-{common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,opcache,soap,zip,intl,bcmath} -y


#chmod +x script-name-here.sh

# replace php.ini file

#cp -f [oringinal file] [new file]

cat config-files/php.ini > /etc/php.ini

cat config-files/www.conf > /etc/php-fpm.d/www.conf

sudo sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php.ini

sudo systemctl restart php-fpm.service



# Create New Server Block Files

sudo mkdir /etc/nginx/sites-available
sudo mkdir /etc/nginx/sites-enabled

# willshub.co


sudo mkdir -p /var/www/willshub.co/public

sudo chown -R $USER:$USER /var/www/willshub.co/public

sudo chcon -t httpd_sys_content_t /var/www/willshub.co -R

sudo chcon -t httpd_sys_rw_content_t /var/www/willshub.co -R


cp -f willshub.co.conf /etc/nginx/sites-available/

sudo ln -s /etc/nginx/sites-available/willshub.co.conf /etc/nginx/sites-enabled/willshub.co.conf


# production-app.willshub.co


sudo mkdir -p /var/www/production-app.willshub.co/public

sudo chown -R $USER:$USER /var/www/production-app.willshub.co/public

sudo chcon -t httpd_sys_content_t /var/www/production-app.willshub.co -R

sudo chcon -t httpd_sys_rw_content_t /var/www/production-app.willshub.co -R


cp -f production-app.willshub.co.conf /etc/nginx/sites-available/

sudo ln -s /etc/nginx/sites-available/production-app.willshub.co.conf /etc/nginx/sites-enabled/production-app.willshub.co.conf


# staging-app.willshub.co


sudo mkdir -p /var/www/staging-app.willshub.co/public

sudo chown -R $USER:$USER /var/www/staging-app.willshub.co/public

sudo chcon -t httpd_sys_content_t /var/www/staging-app.willshub.co -R

sudo chcon -t httpd_sys_rw_content_t /var/www/staging-app.willshub.co -R


cp -f staging-app.willshub.co.conf /etc/nginx/sites-available/

sudo ln -s /etc/nginx/sites-available/staging-app.willshub.co.conf /etc/nginx/sites-enabled/staging-app.willshub.co.conf



sudo systemctl restart nginx