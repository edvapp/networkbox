#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa

cd ${TFTP_DIRECTORY}/grub
for file in $(ls);
do
	# set tftp server name
	sed -e "{
		s/tftp01/${TFTP_SERVER_NAME}/g
	}" -i ${file}
	printAndLogMessage "Set tftp server name in grub-config-file: " ${TFTP_DIRECTORY}/grub/${file}

done
