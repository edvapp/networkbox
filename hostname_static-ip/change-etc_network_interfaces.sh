#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/network/interfaces
printAndLogMessage "Manipulated file: " $file

printAndLogMessage "Check if any interface does a have static ip"
if  grep 'inet static' $file;
then
	printAndLogMessage "Host" $(hostname) "already has static ip -"$(grep address $file)
	printAndLogMessage "did not change ip address"
	exit
fi

printAndLogMessage "Get interface name of active network interfaces"
FIRST_ACTIVE_INTERFACE=$(ip link | grep "state UP" | awk '{print $2}' | sed 's/://' | head -1)
ACTIVE_INTERFACES=$(ip link | grep "state UP" | awk '{print $2}' | sed 's/://')

printAndLogMessage "FIRST_ACTIVE_INTERFACE: " $FIRST_ACTIVE_INTERFACE
printAndLogMessage "ACTIVE_INTERFACES: " $ACTIVE_INTERFACES

if [ "$FIRST_ACTIVE_INTERFACE" != "$ACTIVE_INTERFACES" ];
then
	printAndLogMessage "You have more than one active network interface:"
	printAndLogMessage $ACTIVE_INTERFACES
	printAndLogMessage "Please type in the name, which shall become the static interface"
	read INTERFACE
else
	INTERFACE=$FIRST_ACTIVE_INTERFACE
fi

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Write new static configuration to " $file
if   grep "auto $INTERFACE" $file ;
then
	printAndLogMessage "Comment out dhcp: iface $INTERFACE inet dhcp"
	echo "# interface $INTERFACE changed by networkbox" >> $file
	sed -e "{
		/iface $INTERFACE/ s/iface $INTERFACE/#iface $INTERFACE/
	}" -i $file
else
	printAndLogMessage "Add auto $INTERFACE to $file "
	echo "" >> $file
	echo "# interface $INTERFACE added by networkbox" >> $file
	echo "auto $INTERFACE" >> $file
fi

printAndLogMessage "Append new interface configuration to " $file
echo "iface $INTERFACE inet static
    address $STATIC_IP
    netmask $NETMASK
    network $NETWORK
    broadcast $BROADCAST
    gateway $GATEWAY
    dns-nameservers $DNS_IP_LOCAL_NETWORK $DNS_IP_PROVIDER $DNS_IP_WWW
    dns-search $DOMAIN_NAME
    
" >> $file

printAndLogMessage "Restart network interface with: " $file
logFile $file
ifdown $INTERFACE
ifup $INTERFACE





