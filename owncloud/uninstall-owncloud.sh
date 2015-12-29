#!/bin/bash

# uninstall owncloud 

CURRENT_DIR=$(pwd)

# uninstall mysql-server
cd ../sql-server
/bin/bash uninstall-sql_server.sh
cd $CURRENT_DIR

# uninstall apache
cd ../web-server
/bin/bash uninstall-web_server.sh
cd $CURRENT_DIR

apt-get -y purge owncloud

rm -R /etc/apt/sources.list.d/owncloud.list

ocpath='/var/www/owncloud'

rm -R $ocpath