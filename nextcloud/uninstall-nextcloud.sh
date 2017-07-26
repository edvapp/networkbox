#!/bin/bash

# uninstall owncloud in reverse order

CURRENT_DIR=$(pwd)

# uninstall apache
cd ../web-server
/bin/bash uninstall-web_server.sh
cd $CURRENT_DIR

rm -R /var/www/nextcloud

# uninstall mysql-server
cd ../sql-server
/bin/bash uninstall-sql_server.sh
cd $CURRENT_DIR

apt-get -y autoremove
