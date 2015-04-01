#!/bin/bash

# install isc-dhcp-server
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi
apt-get -y install isc-dhcp-server

service isc-dhcp-server stop

## Configuration dhcp -server
# tell dhcp - server on witch interfaces dhcp - services should be offered
/bin/bash change-etc_default_isc-dhcp-server.sh
# write dhcpd.conf - file
/bin/bash write-etc_dhcp_dhcpd.conf.sh

service isc-dhcp-server start

 
