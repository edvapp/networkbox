#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# get interface name of active network interfaces
FIRST_ACTIVE_INTERFACE=$(ip link | grep "UP mode" | awk '{print $2}' | sed 's/://' | head -1)
ACTIVE_INTERFACES=$(ip link | grep "UP mode" | awk '{print $2}' | sed 's/://')

if [ "$FIRST_ACTIVE_INTERFACE" != "$ACTIVE_INTERFACES" ];
then
	echo "You have more than one active network interface:"
	echo $LIST
	echo "Please type in the name, which shall become the dhcp interface"
	read DHCP_INTERFACES
else
	DHCP_INTERFACES=$FIRST_ACTIVE_INTERFACE
fi

# manipulated file
file=/etc/default/isc-dhcp-server

# save original.conf.options
saveOriginal $file

sed -e "{
	/INTERFACES=\"\"/ s/INTERFACES=\"\"/INTERFACES=\"$DHCP_INTERFACES\"/
}" -i $file


