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

echo "webserver installation with https"

export DEBIAN_FRONTEND=noninteractive 	
apt-get -q -y install apache2

# from: https://doc.owncloud.org/server/8.2/admin_manual/installation/source_installation.html#example-installation-on-ubuntu-14-04-lts-server
# Apache installed under Ubuntu comes already set-up with a simple self-signed certificate. 
# All you have to do is to enable the ssl module and the default site. Open a terminal and run:
a2enmod ssl
a2ensite default-ssl
service apache2 reload



