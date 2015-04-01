#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/network/interfaces

# check if interface eth0 does not have static ip
if  grep 'iface eth0 inet static' $file;
then
	echo "host" $(hostname) "already has static ip -"$(grep address $file)
	echo "did not change anything"
	exit
fi

# save /etc/network/interfaces
saveOriginal $file

# comment original iface eth0 out
sed -e "{
	/iface eth0/ s/iface eth0/#iface eth0/
}" -i $file

# append new interface configuration
echo "
iface eth0 inet static
    address $STATIC_IP
    netmask $NETMASK
    network $NETWORK
    broadcast $BROADCAST
    gateway $GATEWAY
    dns-nameservers $DNS_IP_LOCAL_NETWORK $DNS_IP_PROVIDER $DNS_IP_WWW
    dns-search $DOMAIN_NAME
" >> $file

# restart network interface
ifdown eth0
ifup eth0





