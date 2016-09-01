#!/usr/bin/env bash

# Use single quotes instead of double quotes to make it work with special-character passwords
PROJECTNAME='myproject'
PASSWORDROOT='12345678'
TIMEZONE='Europe/Madrid'
USERDB='usermyproject'
PASSWORDDB='pass'

# update
sudo apt-get update

# install apache 2.5 and php 5.5
sudo apt-get install -y apache2
sudo apt-get install -y php5

# install mysql and give password to installer
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password password $PASSWORDROOT"
sudo debconf-set-selections <<< "mysql-server mysql-server/root_password_again password $PASSWORDROOT"
sudo apt-get -y install mysql-server
sudo apt-get install php5-mysql

# Set timezone
echo "$TIMEZONE" | sudo tee /etc/timezone
sudo dpkg-reconfigure --frontend noninteractive tzdata

# Setup database
echo "DROP DATABASE IF EXISTS $PROJECTNAME" | mysql -uroot -p$PASSWORDROOT
echo "CREATE USER '$USERDB'@'localhost' IDENTIFIED BY '$USERDB'" | mysql -uroot -p$PASSWORDROOT
echo "CREATE DATABASE $PROJECTNAME" | mysql -uroot -p$PASSWORDROOT
echo "GRANT ALL ON $PROJECTNAME.* TO '$USERDB'@'localhost'" | mysql -uroot -p$PASSWORDROOT
echo "FLUSH PRIVILEGES" | mysql -uroot -p$PASSWORDROOT


#Import database
mysql -uroot -p$PASSWORDROOT $PROJECTNAME < /var/sql/database.sql


# install phpmyadmin and give password(s) to installer
# for simplicity I'm using the same password for mysql and phpmyadmin
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/dbconfig-install boolean true"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/app-password-confirm password $PASSWORDROOT"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/admin-pass password $PASSWORDROOT"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/mysql/app-pass password $PASSWORDROOT"
sudo debconf-set-selections <<< "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2"
sudo apt-get -y install phpmyadmin

# setup hosts file
VHOST=$(cat <<EOF
<VirtualHost *:80>
    DocumentRoot "/var/www/html"
    <Directory "/var/www/html">
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
EOF
)
echo "${VHOST}" > /etc/apache2/sites-available/000-default.conf

# enable mod_rewrite
sudo a2enmod rewrite

#install mcrypt
sudo apt-get install php5-mcrypt
sudo php5enmod mcrypt

# restart apache
service apache2 restart

# install git
sudo apt-get -y install git

# install Composer
curl -s https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer
