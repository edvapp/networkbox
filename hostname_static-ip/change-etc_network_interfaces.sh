#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/network/interfaces

if [ "$LXD_CONTAINER" = "yes" ];
then
	printAndLogMessage "path for network-config-file in a LXD Container:"
	file=/etc/network/interfaces.d/50-cloud-init.cfg
fi
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

if [ "$LXD_CONTAINER" = "yes" ];
then
	printAndLogMessage "Set INTERFACE=eth0"
	INTERFACE=eth0
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

printAndLogMessage "Network interface started with: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Restart $INTERFACE"
ifdown $INTERFACE
ifup $INTERFACE
printAndLogMessage "Network interface started with: " $file
logFile $file

if [ "$LXD_CONTAINER" = "yes" ];
then
	printAndLogMessage "Container has to be rebooted for new interface configuration"
	reboot
fi

if [ "$CREATE_BRIDGE" = "yes" ];
then
	printAndLogMessage "Change network settings to use br0"
	printAndLogMessage "Install bridge-utils"
	apt-get -y install bridge-utils
	
	printAndLogMessage "Stop interface $INTERFACE"
	ifdown $INTERFACE

	# change auto $INTERFACE to auto br0
	sed -e "{
		/auto $INTERFACE/ s/auto $INTERFACE/auto br0/
	}" -i $file
	
	# change iface $INTERFACE inet static to iface br0 inet static
	sed -e "{
		/iface $INTERFACE/ s/iface $INTERFACE/iface br0/
	}" -i $file
	
	# append bridge_ports $INTERFACE with 4 spaces (\ ) after dns-search $DOMAIN_NAME
	sed -e "{
		/dns-search/ a \ \ \ \ bridge_ports $INTERFACE
	}" -i $file

	#printAndLogMessage "Start interface br0"
	#ifup br0
	printAndLogMessage "Network interface congigured with: " $file
	logFile $file
	printAndLogMessage "Reboot to get rid off $INTERFACE"
	reboot
fi







