#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
#file=/etc/network/interfaces
file=/etc/network/interfaces

# save original.conf.options
saveOriginal $file

# add own ip to dns-nameservers in /etc/network/interfaces
sed -e "{
	/dns-nameservers/ s/dns-nameservers/dns-nameservers $STATIC_IP/
}" -i $file

# restart network interface
ifdown eth0
ifup eth0





