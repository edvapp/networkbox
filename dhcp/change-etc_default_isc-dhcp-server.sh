#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/default/isc-dhcp-server

# save original.conf.options
saveOriginal $file

sed -e "{
	/INTERFACES=\"\"/ s/INTERFACES=\"\"/INTERFACES=\"$DHCP_INTERFACES\"/
}" -i $file


