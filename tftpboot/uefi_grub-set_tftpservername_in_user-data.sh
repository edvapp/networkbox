#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa

cd ${HTTP_ISO_YAML_LAUS_DIR}/2P1F2F
for file in $(ls);
do
	# set tftp server name
	sed -e "{
		s/tftp01/${TFTP_SERVER_NAME}/g
	}" -i $file
	printAndLogMessage "Set tftp server name in user-data config-file: " ${HTTP_ISO_YAML_LAUS_DIR}/$file

done

cd ${HTTP_ISO_YAML_LAUS_DIR}/2P1F
for file in $(ls);
do
	# set tftp server name
	sed -e "{
		s/tftp01/${TFTP_SERVER_NAME}/g
	}" -i $file
	printAndLogMessage "Set tftp server name in user-data config-file: " ${HTTP_ISO_YAML_LAUS_DIR}/$file

done
