#!/bin/bash

# install isc-dhcp-server
apt-get -y update
apt-get -y install isc-dhcp-server

## Configuration dhcp -server
# tell dhcp - server on witch interfaces dhcp - services should be offered
/bin/bash change-etc_default_isc-dhcp-server.sh
# write dhcpd.conf - file
/bin/bash write-etc_dhcp_dhcpd.conf.sh

/etc/init.d/isc-dhcp-server restart

 
