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
apt-get -q -y install apache2 libapache2-mod-php7.0
apt-get -q -y install php7.0-gd php7.0-json php7.0-mysql php7.0-curl php7.0-mbstring
apt-get -q -y install php7.0-intl php7.0-mcrypt php-imagick php7.0-xml php7.0-zip

# from: https://doc.owncloud.org/server/8.2/admin_manual/installation/source_installation.html
# example-installation-on-ubuntu-14-04-lts-server
# Apache installed under Ubuntu comes already set-up with a simple self-signed certificate. 
# All you have to do is to enable the ssl module and the default site. Open a terminal and run:
printAndLogMessage "enable module ssl with: a2enmod ssl"
a2enmod ssl
printAndLogMessage "enable site default-ssl in /etc/apache2/site-available/default-sll.conf with: a2ensite default-ssl"
a2ensite default-ssl
# restart apache2
service apache2 reload



