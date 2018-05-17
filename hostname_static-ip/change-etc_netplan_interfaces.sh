#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# created file
file=/etc/netplan/50-static-interface.yaml

printAndLogMessage "Save all yaml files in /etc/netplan"
cd /etc/netplan
for toSaveFile in *.yaml;
do
	mv $toSaveFile $toSaveFile.save
done

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

getCIDRsubnetmask $NETMASK
printAndLogMessage "Append new interface configuration to " $file
echo "
network:
  version: 2
  renderer: networkd
  ethernets:
    $INTERFACE:
      addresses: 
        - $STATIC_IP/$CIDR_SUBNETMASK
      gateway4: $GATEWAY
      nameservers:
          search: [$DOMAIN_NAME]
          addresses: [$DNS_IP_LOCAL_NETWORK, $DNS_IP_PROVIDER, $DNS_IP_WWW]   
" >> $file

printAndLogMessage "netplan apply " $file
netplan apply
