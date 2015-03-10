#!/bin/bash

# uninstall isc-dhcp-server

apt-get -y purge isc-dhcp-server

rm /etc/default/isc-dhcp-server
cp /etc/default/isc-dhcp-server.original /etc/default/isc-dhcp-server

rm /etc/dhcp/dhcpd.conf
cp /etc/dhcp/dhcpd.conf.original /etc/dhcp/dhcpd.conf

/etc/init.d/isc-dhcp-server restart

 
