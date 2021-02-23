#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa

cd ${TFTP_DIRECTORY}/ubuntu-installer/menus/boot-screens
for file in $(ls);
do
	if  grep 'MENU PASSWD' $file;
	then
		printAndLogMessage "Set password for tftp boot screen in " ${file}
		sed -e "{
		/MENU PASSWD/ s/MENU PASSWD/MENU PASSWD ${TFTP_MENU_PASSWD}/
		}" -i $file
	fi
done
