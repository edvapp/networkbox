#!/bin/bash

# install isc-dhcp-server
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi
apt-get -y install tftpd-hpa

## Configuration tftp -server
# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa
cp -R pxelinux.cfg	$TFTP_DIRECTORY
cp -R ubuntu-installer	$TFTP_DIRECTORY
cp -R preseed		$TFTP_DIRECTORY

# set password for tftp boot screen
/bin/bash config-tftp_bootmenu.sh

# config pressed - file
/bin/bash config-preseed.sh

# download ubuntu - kernel - images 
/bin/bash wget-Ubuntu.sh


 
