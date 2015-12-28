#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogMessage "apt-get -q -y install mysql-server"
export DEBIAN_FRONTEND=noninteractive 	
apt-get -q -y install mysql-server

printAndLogMessage "Set password for user root for SQL-Server"
mysqladmin -u root password $SQL_SERVER_ROOT_PASSWORD
