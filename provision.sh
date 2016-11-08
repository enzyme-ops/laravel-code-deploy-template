#!/bin/bash

# Add Ruby2.0 respository
add-apt-repository -y ppa:brightbox/ruby-ng-experimental

# Add node source respository
curl -sL https://deb.nodesource.com/setup_6.x | sudo -E bash -

# Update APT
apt update

# Install dependencies
apt install -y php7.0 php7.0-mbstring php7.0-xml php7.0-zip php7.0-mysql git nginx software-properties-common python-software-properties python-pip wget nodejs ruby2.0

# Upgrade dependencies
apt upgrade -y

# Composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php composer-setup.php -- --install-dir=/usr/bin --filename=composer
rm composer-setup.php

# Install AWS CLI
pip install awscli

# Install AWS codedeploy agent
wget https://aws-codedeploy-ap-southeast-2.s3.amazonaws.com/latest/install
chmod +x ./install
./install auto
service codedeploy-agent start
rm -rf install

# Set cgi.fix_pathinfo=0 in php.ini
sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/fpm/php.ini

# Create nginx default config
echo "server {" > /etc/nginx/sites-available/default
echo "        listen 80 default_server;" >> /etc/nginx/sites-available/default
echo "        listen [::]:80 default_server;" >> /etc/nginx/sites-available/default
echo "" >> /etc/nginx/sites-available/default
echo "        root /var/www/public;" >> /etc/nginx/sites-available/default
echo "" >> /etc/nginx/sites-available/default
echo "        index index.php index.html;" >> /etc/nginx/sites-available/default
echo "" >> /etc/nginx/sites-available/default
echo "        server_name _;" >> /etc/nginx/sites-available/default
echo "" >> /etc/nginx/sites-available/default
echo "        location / {" >> /etc/nginx/sites-available/default
echo "                try_files \$uri \$uri/ /index.php;" >> /etc/nginx/sites-available/default
echo "        }" >> /etc/nginx/sites-available/default
echo "" >> /etc/nginx/sites-available/default
echo "        location ~* (index)\.php\$ {" >> /etc/nginx/sites-available/default
echo "                include snippets/fastcgi-php.conf;" >> /etc/nginx/sites-available/default
echo "" >> /etc/nginx/sites-available/default
echo "                fastcgi_pass unix:/run/php/php7.0-fpm.sock;" >> /etc/nginx/sites-available/default
echo "        }" >> /etc/nginx/sites-available/default
echo "" >> /etc/nginx/sites-available/default
echo "        location ~ /\.ht {" >> /etc/nginx/sites-available/default
echo "                deny all;" >> /etc/nginx/sites-available/default
echo "        }" >> /etc/nginx/sites-available/default
echo "}" >> /etc/nginx/sites-available/default

# Restart php and nginx
service php7.0-fpm reload
service nginx reload

# Remove default web directory
rm -rf /var/www/html
