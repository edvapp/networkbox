#!/bin/bash

# uninstall owncloud in reverse order

CURRENT_DIR=$(pwd)

apt-get -y purge owncloud owncloud-server owncloud-config-apache

rm -R /etc/apt/sources.list.d/owncloud.list

ocpath='/var/www/owncloud'
rm -R $ocpath

# uninstall apache
cd ../web-server
/bin/bash uninstall-web_server.sh
cd $CURRENT_DIR

# uninstall mysql-server
cd ../sql-server
/bin/bash uninstall-sql_server.sh
cd $CURRENT_DIR

apt-get -y autoremove
