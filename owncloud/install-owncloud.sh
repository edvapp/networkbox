#!/bin/bash

# install owncloud 
# install owncloud dpkg - package

CURRENT_DIR=$(pwd)

# silent install of mysql-server
cd ../sql-server
/bin/bash install-sql_server.sh
cd $CURRENT_DIR

# create database & database-admin for owncloud_database
echo "Setup mysql database for owncloud" 
echo "from http://raspberry.tips/server-2/owncloud-8-1-auf-dem-raspberry-pi-2-mit-apache/"
cd ../sql-database
/bin/bash install-database.sh
cd $CURRENT_DIR

# install apache with https
echo "Install web-server with https"
cd ../web-server
/bin/bash install-web_server.sh
cd $CURRENT_DIR

echo "Install OWNCLOUD"
echo "Install repo key"
wget -nv https://download.owncloud.org/download/repositories/stable/$(lsb_release -si)_$(lsb_release -sr)/Release.key -O- | apt-key add - 

echo "Adding repo entry"
echo "deb http://download.owncloud.org/download/repositories/stable/$(lsb_release -si)_$(lsb_release -sr)/ /" >> /etc/apt/sources.list.d/owncloud.list

apt-get update

apt-get -y install owncloud


echo "Setting Strong Directory Permissions"
echo "from owncloud homepage"
ocpath='/var/www/owncloud'
htuser='www-data'
htgroup='www-data'
rootuser='root' # On QNAP this is admin

find ${ocpath}/ -type f -print0 | xargs -0 chmod 0640
find ${ocpath}/ -type d -print0 | xargs -0 chmod 0750

chown -R ${rootuser}:${htgroup} ${ocpath}/
chown -R ${htuser}:${htgroup} ${ocpath}/apps/
chown -R ${htuser}:${htgroup} ${ocpath}/config/
chown -R ${htuser}:${htgroup} ${ocpath}/data/
chown -R ${htuser}:${htgroup} ${ocpath}/themes/

chown ${rootuser}:${htgroup} ${ocpath}/.htaccess
chown ${rootuser}:${htgroup} ${ocpath}/data/.htaccess

chmod 0644 ${ocpath}/.htaccess
chmod 0644 ${ocpath}/data/.htaccess

/bin/bash connect_owncloud_and_db.sh

