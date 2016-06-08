#!/bin/bash

# uninstall isc-dhcp-server

apt-get -y purge isc-dhcp-server

rm /etc/default/isc-dhcp-server.original
rm /etc/default/isc-dhcp-server.history.*

rm /etc/dhcp/dhcpd.conf.original
rm /etc/dhcp/dhcpd.conf.history.*

rm -f -R /etc/dhcp/.git
rm /etc/dhcp/.gitignore

 
