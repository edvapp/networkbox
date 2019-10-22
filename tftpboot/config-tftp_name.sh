#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa

cd $TFTP_DIRECTORY/preseed
for file in $(ls);
do
	# set tftp server name
	sed -e "{
		/d-i preseed\/late_command/ s/tftp01/$TFTP_SERVER_NAME/g
	}" -i $file
	printAndLogMessage "Set tftp server name in preseed-file: " $TFTP_DIRECTORY/preseed/$file

done

cd $TFTP_DIRECTORY/ubuntu-installer/menus/boot-screens
for file in $(ls);
do
	# set tftp server name
	sed -e "{
		s/tftp01/$TFTP_SERVER_NAME/
	}" -i $file
	printAndLogMessage "Set tftp server name in menu-config-file: " $TFTP_DIRECTORY/ubuntu-installer/menus/boot-screens/$file

done
