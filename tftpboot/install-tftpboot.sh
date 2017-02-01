#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# install isc-dhcp-server
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogStartMessage "START: INSTALLATION OF TFTP - SERVER"

printAndLogMessage "apt-get -y install tftpd-hpa"
apt-get -y install tftpd-hpa

printAndLogMessage "CONFIGURATION OF TFTP - SERVER"
# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa
printAndLogMessage "cp -R pxelinux.cfg $TFTP_DIRECTORY"
printAndLogMessage "cp -R ubuntu-installer $TFTP_DIRECTORY"
printAndLogMessage "cp -R preseed $TFTP_DIRECTORY"
cp -R pxelinux.cfg 	$TFTP_DIRECTORY
cp -R ubuntu-installer	$TFTP_DIRECTORY
cp -R preseed		$TFTP_DIRECTORY

printAndLogMessage "SET PASSWORD FOR TFTP-BOOT-SCREEN"
/bin/bash config-tftp_bootmenu.sh

printAndLogMessage "SET ADMIN & ADMIN-PASSWORD FOR WORKSTATIONS IN PRESEED - FILES"
/bin/bash config-preseed.sh

printAndLogMessage "SET TFTP-Servername IN PRESEED - FILES AND BOOTSCREENS MENU.CFG"
/bin/bash config-tftp_name.sh

printAndLogMessage "DOWNLOAD UBUNTU - KERNEL IMAGES"
/bin/bash wget-Ubuntu.sh

printAndLogEndMessage "FINISH: INSTALLATION OF TFTP - SERVER"

 
