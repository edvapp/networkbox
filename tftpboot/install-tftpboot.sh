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

# source /etc/default/tftpd-hpa
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa


#### CONFIGURATION FOR ***LEGACY-PXE-PART*** ON TFTP - SERVER
printAndLogMessage "CONFIGURATION FOR ***LEGACY-PXE-PART*** ON TFTP - SERVER"

printAndLogMessage "cp -R pxelinux.cfg $TFTP_DIRECTORY"
printAndLogMessage "cp -R ubuntu-installer $TFTP_DIRECTORY"
printAndLogMessage "cp -R preseed $TFTP_DIRECTORY"
cp -R pxelinux.cfg 	$TFTP_DIRECTORY
cp -R ubuntu-installer	$TFTP_DIRECTORY
cp -R preseed		$TFTP_DIRECTORY

printAndLogMessage "SET PASSWORD FOR TFTP-LEGACY-PXE-BOOT-SCREEN"
/bin/bash config-tftp_bootmenu.sh

printAndLogMessage "SET ADMIN & ADMIN-PASSWORD FOR WORKSTATIONS IN LEGACY-PXE-PRESEED - FILES"
/bin/bash config-preseed.sh

printAndLogMessage "SET TFTP-Servername IN LEGACY-PXE-PRESEED - FILES AND LEGACY-PXE-BOOTSCREENS MENU.CFG"
/bin/bash config-tftp_name.sh

printAndLogMessage "DOWNLOAD UBUNTU - LEGACY-PXE-BOOT FILES and KERNEL IMAGES"
/bin/bash wget-legacy-pxe-Ubuntu.sh


#### CONFIGURATION FOR ***UEFI-GRUB-SERVER_ISO-PART*** ON TFTP - SERVER
printAndLogMessage "CONFIGURATION FOR ***UEFI-GRUB-SERVER_ISO-PART*** ON TFTP - SERVER"

printAndLogMessage "cp -R grub $TFTP_DIRECTORY"
cp -R grub $TFTP_DIRECTORY

printAndLogMessage "DOWNLOAD UBUNTU - UEFI-GRUB-BOOT FILES"
/bin/bash wget-uefi-grub-Ubuntu.sh

printAndLogMessage "INSTALL Apache - Webserver to serve ISO-image and YAML-configfiles"
apt-get -y install apache2

printAndLogMessage "create directory for ISO-image and YAML-configfiles"
#TODO

printAndLogMessage "DOWNLOAD Ubuntu Server-ISO-IMAGE TO WEBSERVER_SUBDIRECTORY"
#TODO

printAndLogMessage "extract KERNEL & INITRD from ISO and copy to tftp subdirectory"
#TODO

printAndLogMessage "COPY user-data & meta-data YAML FILES to WEBSERVER-SUBDIRECTORY"
#TODO

printAndLogEndMessage "FINISH: INSTALLATION OF TFTP - SERVER"

 
