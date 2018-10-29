#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

## sql command to create an DATABASE-ADMIN user
SQL_COMMAND="CREATE DATABASE ${DB}; \
CREATE USER '${DB_ADMIN}'@'localhost' IDENTIFIED BY '${DB_ADMIN_PASSWORD}'; \
GRANT ALL PRIVILEGES ON ${DB}.* TO '${DB_ADMIN}'@'localhost'; \
FLUSH PRIVILEGES;"
#mysql -u root -p$SQL_SERVER_ROOT_PASSWORD -e "$SQL_COMMAND"
mysql -u root -e "$SQL_COMMAND"


## harden mariadb installation 
## commands taken from script /usr/bin/mysql_secure_installation

# Kill the anonymous users
#mysql -u root -e "DROP USER ''@'localhost'"
# Because our hostname varies we'll use some Bash magic here.
#mysql -u root -e "DROP USER ''@'$(hostname)'"
# Kill off the demo database
#mysql -u root -e "DROP DATABASE test"
# Make sure that NOBODY can access the server without a password
mysql -u root -e "UPDATE mysql.user SET Password = PASSWORD('$SQL_SERVER_ROOT_PASSWORD') WHERE User = 'root'"
# Make our changes take effect
mysql -u root -e "FLUSH PRIVILEGES"
# Any subsequent tries to run queries this way will get access denied because lack of usr/pwd param
