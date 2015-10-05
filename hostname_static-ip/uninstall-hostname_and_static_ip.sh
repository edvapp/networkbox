#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

restoreOriginal /etc/network/interfaces

restoreOriginal /etc/hostname
# set hostname for running system
hostname $(cat /etc/hostname)

restoreOriginal /etc/hosts

# restart all active network interface
# get interface name of active network interfaces
ACTIVE_INTERFACES=$(ip link | grep "UP mode" | awk '{print $2}' | sed 's/://')

for ACTIVE_INTERFACE in ${ACTIVE_INTERFACES[@]}; 
do
	ifdown $ACTIVE_INTERFACE
	ifup $ACTIVE_INTERFACE
done