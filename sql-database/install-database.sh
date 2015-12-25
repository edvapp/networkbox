#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

mysql -u root -p$SQL_SERVER_ROOT_PASSWORD -e "$SQL_COMMAND"


