#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=dhcpd.cnf

# save original.conf.options
saveOriginal $file

# write /etc/dhcp/dhcpd.conf

echo "
# Sample configuration file for ISC dhcpd for Debian
#
# Attention: If /etc/ltsp/dhcpd.conf exists, that will be used as\n
# configuration file instead of this file.\n
#
#
exit
ddns-update-style none;

# option definitions common to all supported networks...
option domain-name "app.tsn";
option domain-name-servers 10.0.0.1;
option netbios-name-servers smb01;
option ntp-servers ntp01;

# Windows client resolve-order: wins broadcast <- default
# option netbios-node-type 8;

default-lease-time 6000;
max-lease-time 72000;

# If this DHCP server is the official DHCP server for the local
# network, the authoritative directive should be uncommented.
authoritative;

# Use this to send dhcp log messages to a different log file (you also
# have to hack syslog.conf to complete the redirection).
log-facility local7;

use-host-decl-names on;

# volles Netz
subnet 10.0.0.0 netmask 255.248.0.0 {

	option broadcast-address 10.7.255.255;
	option routers 10.0.0.254;

	range 10.5.0.1 10.5.0.245;

	use-host-decl-names on;

	next-server fog01;
	#next-server tftp01;

	#option root-path "/opt/ltsp/i386";

	if substring( option vendor-class-identifier, 0, 9 ) = "PXEClient" 
	{ filename "pxelinux.0"; } 
	else 
	{ filename "/ltsp/i386/nbi.img"; }
}
"