#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

echo "connect owncloud with database"
cd /var/www/owncloud/
sudo -u www-data php occ maintenance:install --database "mysql" --database-name "$DB"  --database-user "$DB_ADMIN" --database-pass "$DB_ADMIN_PASSWORD" --admin-user "$OC_ADMIN" --admin-pass "$OC_ADMIN_PASSWORD"
