#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/hostname

# check if interface eth0 does not have static ip
if  [ $(hostname) = $HOSTNAME ];
then
	echo "hostname" $(hostname) "already OK!"
	exit
fi

OLD_HOSTNAME=$(hostname)

# save /etc/hostname
saveOriginal $file

# change hostname for runnig system
hostname $HOSTNAME

# change hostname file
sed -e "{
	/$OLD_HOSTNAME/ s/$OLD_HOSTNAME/$HOSTNAME/
}" -i $file

# manipulated file
file=/etc/hosts

# save /etc/hosts
saveOriginal $file

# change hosts file
sed -e "{
	/$OLD_HOSTNAME/ s/$OLD_HOSTNAME/$HOSTNAME/
}" -i $file
