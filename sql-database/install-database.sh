#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

## to setup Database for MYSQL 
## for quit install to set password from OPTIONS.conf
## seems not necessary, if using mariadb
SQL_SERVER_ROOT_PASSWORD=root1234

## sql command to create an DATABASE-ADMIN user
SQL_COMMAND="CREATE DATABASE ${DB}; \
CREATE USER '${DB_ADMIN}'@'localhost' IDENTIFIED BY '${DB_ADMIN_PASSWORD}'; \
GRANT ALL PRIVILEGES ON ${DB}.* TO '${DB_ADMIN}'@'localhost'; \
FLUSH PRIVILEGES;"

mysql -u root -p$SQL_SERVER_ROOT_PASSWORD -e "$SQL_COMMAND"


