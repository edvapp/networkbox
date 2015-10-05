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
FIRST_ACTIVE_INTERFACE=$(ip link | grep "UP mode" | awk '{print $2}' | sed 's/://' | head -1)
ACTIVE_INTERFACES=$(ip link | grep "UP mode" | awk '{print $2}' | sed 's/://')

if [ "$FIRST_ACTIVE_INTERFACE" != "$ACTIVE_INTERFACES" ];
then
	echo "You have more than one active network interface:"
	echo $LIST
	echo "Please type in the name, which shall become the static interface"
	read INTERFACE
else
	INTERFACE=$FIRST_ACTIVE_INTERFACE
fi

# write new static configuration to /etc/network/interfaces
if   grep "auto $INTERFACE" $file ;
then
	echo "comment out dhcp: iface $INTERFACE inet dhcp"
	echo "# interface $INTERFACE changed by networkbox" >> $file
	sed -e "{
		/iface $INTERFACE/ s/iface $INTERFACE/#iface $INTERFACE/
	}" -i $file
else
	echo write: auto $INTERFACE
	echo "" >> $file
	echo "# interface $INTERFACE added by networkbox" >> $file
	echo "auto $INTERFACE" >> $file
fi

# append new interface configuration
echo "write interface configuration"
echo "iface $INTERFACE inet static
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





