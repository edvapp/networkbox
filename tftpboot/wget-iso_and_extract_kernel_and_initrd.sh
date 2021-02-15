#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source /etc/default/tftpd-hpa
. /etc/default/tftpd-hpa
# to get variable ${TFTP_DIRECTORY}
# configured in /etc/default/tftpd-hpa

## location ubuntu-server-iso
SOURCE="http://releases.ubuntu.com/focal/"
## location to store ubuntu-server-iso on tftp/http sever
HTTP_DEST="/var/www/html/ubuntu-server-installer/"
## iso-filename 
FILE="ubuntu-20.04.2-live-server-amd64.iso"

printAndLogMessage "create directory for ISO-image and YAML-configfiles"
mkdir -p ${HTTP_DEST} 

if [ ! -e ${HTTP_DEST}${FILE} ];
then
	printAndLogMessage "wget -P "${HTTP_DEST} ${SOURCE}${FILE}
	wget -P ${HTTP_DEST} ${SOURCE}${FILE}
	
	printAndLogMessage "EXTRACT vmlinuz & initrd"
	7z e ${HTTP_DEST}${FILE} casper/vmlinuz
	7z e ${HTTP_DEST}${FILE} casper/initrd
	
	printAndLogMessage "COPY vmlinuz & initrd to tftp subdirectory"
	mkdir ${TFTP_DIRECTORY}/ubuntu-server-installer
	cp vmlinuz ${TFTP_DIRECTORY}/ubuntu-server-installer
	cp initrd ${TFTP_DIRECTORY}/ubuntu-server-installer
fi

