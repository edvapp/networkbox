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

printAndLogMessage "INSTALL WEB - SERVER WITH HTTPS"
cd ../web-server
/bin/bash install-web_server.sh
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

ln -s /etc/apache2/sites-available/nextcloud.conf /etc/apache2/sites-enabled/nextcloud.conf

printAndLogMessage "Enable Apache modules"
a2enmod rewrite
a2enmod headers
a2enmod env
a2enmod dir
a2enmod mime

service apache2 restart

chown -R www-data:www-data /var/www/nextcloud/

cd /var/www/nextcloud/

#sudo -u www-data php occ  maintenance:install --database "mysql" --database-name "nextcloud"  --database-user "root" --database-pass "password" --admin-user "admin" --admin-pass "password"


printAndLogEndMessage "FINISH: INSTALLATION OF OWNCLOUD"

