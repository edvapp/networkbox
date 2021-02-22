#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source /etc/default/tftpd-hpa
. /etc/default/tftpd-hpa
# to get variable ${TFTP_DIRECTORY}
# configured in /etc/default/tftpd-hpa

## location ubuntu-20.04-server-iso
SOURCE="http://releases.ubuntu.com/focal"
## iso-filename 
FILE="ubuntu-20.04.2-live-server-amd64.iso"
SHORT_FILE_NAME="ubuntu-20.04-live-server-amd64.iso"
## kernel & initrd directory in tftp-root-directory
KERNEL_AND_INITRD_DIR="ubuntu-server-installer/20.04"

printAndLogMessage "create directory for ISO-image and YAML-configfiles"
mkdir -p ${HTTP_ISO_YAML_LAUS_DIR}

if [ ! -e ${HTTP_ISO_YAML_LAUS_DIR}/${FILE} ];
then
	printAndLogMessage "wget -P "${HTTP_ISO_YAML_LAUS_DIR} ${SOURCE}/${FILE}
	wget -P ${HTTP_ISO_YAML_LAUS_DIR} ${SOURCE}/${FILE}
	ln ${HTTP_ISO_YAML_LAUS_DIR}/${FILE} ${HTTP_ISO_YAML_LAUS_DIR}/${SHORT_FILE_NAME}
	
	printAndLogMessage "EXTRACT vmlinuz & initrd"
	7z e ${HTTP_ISO_YAML_LAUS_DIR}/${FILE} casper/vmlinuz
	7z e ${HTTP_ISO_YAML_LAUS_DIR}/${FILE} casper/initrd
	
	printAndLogMessage "COPY vmlinuz & initrd to tftp subdirectory"
	mkdir -p ${TFTP_DIRECTORY}/${KERNEL_AND_INITRD_DIR}
	mv vmlinuz ${TFTP_DIRECTORY}/${KERNEL_AND_INITRD_DIR}
	mv initrd ${TFTP_DIRECTORY}/${KERNEL_AND_INITRD_DIR}
fi

### we set all variable new

## location ubuntu-21.04-server-iso
SOURCE="http://cdimage.ubuntu.com/ubuntu-server/daily-live/current"
## iso-filename 
FILE="hirsute-live-server-amd64.iso"
SHORT_FILE_NAME="ubuntu-21.04-live-server-amd64.iso"
## kernel & initrd directory in tftp-root-directory
KERNEL_AND_INITRD_DIR="ubuntu-server-installer/21.04"

printAndLogMessage "create directory for ISO-image and YAML-configfiles"
mkdir -p ${HTTP_ISO_YAML_LAUS_DIR}

if [ ! -e ${HTTP_ISO_YAML_LAUS_DIR}/${FILE} ];
then
	printAndLogMessage "wget -P "${HTTP_ISO_YAML_LAUS_DIR} ${SOURCE}/${FILE}
	wget -P ${HTTP_ISO_YAML_LAUS_DIR} ${SOURCE}/${FILE}
	ln ${HTTP_ISO_YAML_LAUS_DIR}/${FILE} ${HTTP_ISO_YAML_LAUS_DIR}/${SHORT_FILE_NAME}
	
	printAndLogMessage "EXTRACT vmlinuz & initrd"
	7z e ${HTTP_ISO_YAML_LAUS_DIR}/${FILE} casper/vmlinuz
	7z e ${HTTP_ISO_YAML_LAUS_DIR}/${FILE} casper/initrd
	
	printAndLogMessage "COPY vmlinuz & initrd to tftp subdirectory"
	mkdir ${TFTP_DIRECTORY}/${KERNEL_AND_INITRD_DIR}
	mv vmlinuz ${TFTP_DIRECTORY}/${KERNEL_AND_INITRD_DIR}
	mv initrd ${TFTP_DIRECTORY}/${KERNEL_AND_INITRD_DIR}
fi

