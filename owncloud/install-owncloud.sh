#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

printAndLogStartMessage "START: INSTALLATION OF OWNCLOUD"

# install owncloud 
# install owncloud dpkg - package

CURRENT_SUB_DIR=$(pwd)

printAndLogMessage "SILENT INSTALLATION OF MYSQL - SERVER"
cd ../sql-server
/bin/bash install-sql_server.sh
cd $CURRENT_SUB_DIR

printAndLogMessage "CREATE DATABASE & DATABASE-ADMIN FOR OWNCLOUD-DATABASE"
printAndLogMessage "Setup mysql database for owncloud" 
printAndLogMessage "from http://raspberry.tips/server-2/owncloud-8-1-auf-dem-raspberry-pi-2-mit-apache/"
cd ../sql-database
/bin/bash install-database.sh
cd $CURRENT_SUB_DIR

printAndLogMessage "INSTALL WEB - SERVER WITH HTTPS"
cd ../web-server
/bin/bash install-web_server.sh
cd $CURRENT_SUB_DIR

printAndLogMessage "Install owncloud"
printAndLogMessage "Install repository key"
wget -nv https://download.owncloud.org/download/repositories/stable/$(lsb_release -si)_$(lsb_release -sr)/Release.key -O- | apt-key add - 

printAndLogMessage "Adding repo entry to file: /etc/apt/sources.list.d/owncloud.list"
echo "deb http://download.owncloud.org/download/repositories/stable/$(lsb_release -si)_$(lsb_release -sr)/ /" >> /etc/apt/sources.list.d/owncloud.list

printAndLogMessage "apt-get update to get new packages"
printAndLogMessage "apt-get -y install owncloud"

apt-get update
apt-get -y install owncloud


printAndLogMessage "Setting Strong Directory Permissions"
printAndLogMessage "from owncloud homepage"
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

printAndLogMessage "CONNECT OWNCLOUD - DATABASE TO OWNCLOUD"
/bin/bash connect_owncloud_and_db.sh

printAndLogEndMessage "FINISH: INSTALLATION OF OWNCLOUD"

