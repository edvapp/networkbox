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

printAndLogMessage "apt-get -q -y install mariadb-server"
export DEBIAN_FRONTEND=noninteractive 	
apt-get -q -y install mariadb-server
