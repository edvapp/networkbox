#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

printAndLogStartMessage "START: INSTALLATION OF NEXTCLOUD"

CURRENT_SUB_DIR=$(pwd)

printAndLogMessage "SILENT INSTALLATION OF MARIADB-SQL - SERVER"
cd ../sql-server
/bin/bash install-sql_server.sh
cd $CURRENT_SUB_DIR

printAndLogMessage "CREATE DATABASE & DATABASE-ADMIN FOR CLOUD-DATABASE"
printAndLogMessage "Setup mysql database for cloud" 
printAndLogMessage "from http://raspberry.tips/server-2/owncloud-8-1-auf-dem-raspberry-pi-2-mit-apache/"
cd ../sql-database
/bin/bash install-database.sh
cd $CURRENT_SUB_DIR

printAndLogMessage "INSTALL WEB - SERVER WITH HTTPS"
cd ../web-server
/bin/bash install-web_server.sh
printAndLogMessage "Install additional php packages"
apt-get -y install libapache2-mod-php php php-common php-cli php-curl php-gd php-gmp php-imagick php-intl php-json php-mbstring php-mysql php-xmlrpc php-xml php-zip
cd $CURRENT_SUB_DIR

printAndLogMessage "Install nextcloud"

printAndLogMessage "download $NEXTCLOUD_VERSION.tar.bz2"
wget https://download.nextcloud.com/server/releases/$NEXTCLOUD_VERSION.tar.bz2

tar -xjf $NEXTCLOUD_VERSION.tar.bz2 -C /var/www

rm $NEXTCLOUD_VERSION.tar.bz2

printAndLogMessage "Config Apache for nextcloud"
echo "
Alias /nextcloud \"/var/www/nextcloud/\"

<Directory /var/www/nextcloud/>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/nextcloud
 SetEnv HTTP_HOME /var/www/nextcloud
 
 Satisfy Any

</Directory>
" >> /etc/apache2/sites-available/nextcloud.conf

a2ensite nextcloud.conf

printAndLogMessage "Enable more Apache modules"
a2enmod rewrite
a2enmod headers

systemctl restart apache2

chown -R www-data:www-data /var/www/nextcloud/

printAndLogMessage "CONNECT NEXTCLOUD - DATABASE TO NEXTCLOUD"
/bin/bash connect-nextcloud_and_db.sh

printAndLogMessage "SET OWN IP AS SECOND TRUSTED_DOMAIN"
cd /var/www/nextcloud/
sudo -u www-data php occ config:system:set trusted_domains 1 --value=$(hostname -i)
cd $CURRENT_SUB_DIR

printAndLogEndMessage "FINISH: INSTALLATION OF NEXTCLOUD"

