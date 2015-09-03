#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/network/interfaces

# check if any interface does a have static ip
if  grep 'inet static' $file;
then
	echo "host" $(hostname) "already has static ip -"$(grep address $file)
	echo "did not change ip address"
	exit
fi

# save /etc/network/interfaces
saveOriginal $file

# get interface name of active network interfaces
FIRST=$(ip link | grep "UP mode" | awk '{print $2}' | sed 's/://' | head -1)
LIST=$(ip link | grep "UP mode" | awk '{print $2}' | sed 's/://')

if [ "$FIRST" != "$LIST" ];
then
	echo "You have more than one active networkinterface:"
	echo $LIST
	echo "Please type in the name, which shall become the static interface"
	read INTERFACE
else
	INTERFACE=$FIRST
fi


# comment original iface $INTERFACE out
sed -e "{
	/iface $INTERFACE/ s/iface $INTERFACE/#iface $INTERFACE/
}" -i $file

# append new interface configuration
echo "
iface $INTERFACE inet static
    address $STATIC_IP
    netmask $NETMASK
    network $NETWORK
    broadcast $BROADCAST
    gateway $GATEWAY
    dns-nameservers $DNS_IP_LOCAL_NETWORK $DNS_IP_PROVIDER $DNS_IP_WWW
    dns-search $DOMAIN_NAME
" >> $file

# restart network interface
ifdown $INTERFACE
ifup $INTERFACE





