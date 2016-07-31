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
RELEASE=$(lsb_release -si)
printAndLogMessage "Found Release " $RELEASE
if [ $RELEASE = Raspbian ];
then
	RELEASE="Debian"
	printAndLogMessage "Changed Release from Raspbian to Debian"
fi
wget -nv https://download.owncloud.org/download/repositories/stable/${RELEASE}_$(lsb_release -sr)/Release.key -O- | apt-key add - 

printAndLogMessage "Adding repo entry to file: /etc/apt/sources.list.d/owncloud.list"
echo "deb http://download.owncloud.org/download/repositories/stable/${RELEASE}_$(lsb_release -sr)/ /" >> /etc/apt/sources.list.d/owncloud.list

printAndLogMessage "apt-get update to get new packages"
printAndLogMessage "apt-get -y install owncloud"

apt-get update
apt-get -y install owncloud


printAndLogMessage "Setting Strong Directory Permissions"
printAndLogMessage "from owncloud homepage"
/bin/bash set-strong_directory_permissions.sh

printAndLogMessage "CONNECT OWNCLOUD - DATABASE TO OWNCLOUD"
/bin/bash connect-owncloud_and_db.sh

printAndLogEndMessage "FINISH: INSTALLATION OF OWNCLOUD"

