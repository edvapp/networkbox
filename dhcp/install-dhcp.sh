#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# install isc-dhcp-server
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogStartMessage "START: INSTALLATION OF DHCP - SERVER"

printAndLogMessage "apt-get -y install isc-dhcp-server"
apt-get -y install isc-dhcp-server

service isc-dhcp-server stop

## Configuration dhcp -server
printAndLogMessage "TELL DHCP - SERVER INTERFACE TO OFFER SERVICE"
/bin/bash change-etc_default_isc-dhcp-server.sh

if [ "$DHCP_GIT_REPOSITORY" = "" ];
then
    printAndLogMessage "WRITE DHCP - CONFIGURATION"
    /bin/bash write-etc_dhcp_dhcpd.conf.sh
else
    printAndLogMessage "pull DHCP - CONFIGURATION from $DHCP_GIT"
    /bin/bash pull-etc_dhcp_dhcpd.conf.sh
fi

service isc-dhcp-server start

printAndLogEndMessage "FINISH: INSTALLATION OF DHCP - SERVER"

 
