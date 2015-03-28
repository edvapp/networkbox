#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

cd /var/lib/tftpboot/ubuntu-installer/menus/boot-screens
for file in $(ls);
do
	# set password for tftp boot screen
	sed -e "{
		/MENU PASSWD/ s/MENU PASSWD/MENU PASSWD $TFTP_MENU_PASSWD/
	}" -i $file
done