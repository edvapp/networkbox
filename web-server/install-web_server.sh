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

printAndLogMessage "apt-get -q -y install apache2"
export DEBIAN_FRONTEND=noninteractive 	
apt-get -y install apache2 

# from: https://doc.owncloud.org/server/8.2/admin_manual/installation/source_installation.html
# example-installation-on-ubuntu-14-04-lts-server
# Apache installed under Ubuntu comes already set-up with a simple self-signed certificate. 
# All you have to do is to enable the ssl module and the default site. Open a terminal and run:
printAndLogMessage "enable module ssl with: a2enmod ssl"
a2enmod ssl
printAndLogMessage "enable site default-ssl in /etc/apache2/site-available/default-ssl.conf with: a2ensite default-ssl"
a2ensite default-ssl
# reload apache2
systemctl reload apache2



