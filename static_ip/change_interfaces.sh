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

# save original.conf.options
saveOriginal $file

# comment original iface eth0 out
sed -e "{
	/iface eth0/ s/iface eth0/#iface eth0/
}" -i $file

# append new interface configuration
echo "iface eth0 inet static" >> $file
echo "    address" $IP >> $file
echo "    netmask" $NETMASK >> $file
echo "    network" $NETWORK >> $file
echo "    broadcast" $BROADCAST >> $file
echo "    gateway" $GATEWAY >> $file
echo "    dns-nameservers" $DNS_1 $DNS_2 $DNS_3 >> $file

# restart network interface
ifdown eth0
ifup eth0





