#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/dhcp/dhcpd.conf

# save original.conf.options
saveOriginal $file

rm $file

# write /etc/dhcp/dhcpd.conf new

echo "
# Sample configuration file for ISC dhcpd for Debian
#
# Attention: If /etc/ltsp/dhcpd.conf exists, that will be used as\n
# configuration file instead of this file.\n
#
#
ddns-update-style none;

# option definitions common to all supported networks...
option domain-name \"$DHCP_DNS_DOMAIN_NAME\";
option domain-name-servers $DHCP_DNS_IP;
#option netbios-name-servers smb01;
#option ntp-servers ntp01;

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

# full network
subnet $DHCP_NETWORK netmask $DHCP_NETMASK {

	option broadcast-address $DHCP_BROADCAST;
	option routers $DHCP_GATEWAY;

	range $DHCP_MIN_RANGE $DHCP_MIN_RANGE;

	next-server tftp01;

	if substring( option vendor-class-identifier, 0, 9 ) = \"PXEClient\" 
	{
		filename \"pxelinux.0\"; 
	} 
	else 
	{ 
		filename \"/ltsp/i386/nbi.img\"; 
	}
}

### room 001 room 001 room 001 room 001 room 001

	group {
		#next-server tftp01;

		host $DHCP_HOST_1_HOSTNAME { hardware ethernet $DHCP_HOST_1_MAC; fixed-address $DHCP_HOST_1_IP; }
		# host r001pc02 and so on
	}

### room 001 room 001 room 001 room 001 room 001

	
### room 002 room 002 room 002 room 002 room 002

	group {
		next-server tftp01;

		host $DHCP_HOST_2_HOSTNAME { hardware ethernet $DHCP_HOST_2_MAC; fixed-address $DHCP_HOST_2_IP; }
	}

### room 002 room 002 room 002 room 002 room 002

" >> $file