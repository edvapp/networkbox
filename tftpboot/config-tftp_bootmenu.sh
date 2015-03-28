#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

for file in $(ls /var/lib/tftpboot/ubuntu-installer/menus/boot-screens);
do
	# set password for tftp boot screen
	sed -e "{
		/MENU PASSWD/ s/MENU PASSWD/MENU PASSWD $TFTP_MENU_PASSWD/
	}" -i $file
done