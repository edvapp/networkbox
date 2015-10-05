#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

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


