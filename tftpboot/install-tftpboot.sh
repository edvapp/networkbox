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
# to get variable ${TFTP_DIRECTORY}
# configured in /etc/default/tftpd-hpa


#### CONFIGURATION FOR ***LEGACY-PXE-PART*** ON TFTP - SERVER
printAndLogMessage "CONFIGURATION FOR ***LEGACY-PXE-PART*** ON TFTP - SERVER"

printAndLogMessage "cp -R pxelinux.cfg ${TFTP_DIRECTORY}"
printAndLogMessage "cp -R ubuntu-installer ${TFTP_DIRECTORY}"
printAndLogMessage "cp -R preseed ${TFTP_DIRECTORY}"
cp -R pxelinux.cfg 	${TFTP_DIRECTORY}
cp -R ubuntu-installer	${TFTP_DIRECTORY}
cp -R preseed		${TFTP_DIRECTORY}

printAndLogMessage "SET PASSWORD FOR TFTP-LEGACY-PXE-BOOT-SCREEN"
/bin/bash config-legacy_pxe_bootmenu.sh

printAndLogMessage "SET TFTP-Servername IN LEGACY-PXE-PRESEED - FILES AND LEGACY-PXE-BOOTSCREENS MENU.CFG"
/bin/bash config-legacy_pxe_tftpservername.sh

printAndLogMessage "SET ADMIN & ADMIN-PASSWORD FOR WORKSTATIONS IN LEGACY-PXE-PRESEED - FILES"
/bin/bash config-legacy_pxe_preseed.sh

printAndLogMessage "DOWNLOAD UBUNTU - LEGACY-PXE-BOOT FILES and KERNEL IMAGES"
/bin/bash wget-legacy_pxe_ubuntustaff.sh


#### CONFIGURATION FOR ***UEFI-GRUB-SERVER_ISO-PART*** ON TFTP - SERVER
printAndLogMessage "CONFIGURATION FOR ***UEFI-GRUB-SERVER_ISO-PART*** ON TFTP - SERVER"

printAndLogMessage "COPY GRUB - CONFIGFILE to ${TFTP_DIRECTORY}/grub"
cp -R grub ${TFTP_DIRECTORY}

printAndLogMessage "SET TFTP-Servername IN GRUB - FILE"
#TODO: /bin/bash config-uefi_grub_tftpservername.sh

printAndLogMessage "DOWNLOAD UBUNTU - UEFI-GRUB-BOOT FILES"
/bin/bash wget-uefi_grub_ubuntustaff.sh

printAndLogMessage "INSTALL Apache - Webserver to serve ISO-image and YAML-configfiles"
printAndLogMessage "INSTALL p7zip-full to extract kernel and initrd from iso"
apt-get -y install apache2 p7zip-full

printAndLogMessage "DOWNLOAD Ubuntu Server-ISO-IMAGE TO WEBSERVER_SUBDIRECTORY"
/bin/bash wget-iso_and_extract_kernel_and_initrd.sh

printAndLogMessage "COPY user-data & meta-data YAML FILES to WEBSERVER-SUBDIRECTORY"
cp server-install-data/user-data ${HTTP_DEST}
cp server-install-data/meta-data ${HTTP_DEST}

printAndLogMessage "SET ADMIN & ADMIN-PASSWORD FOR WORKSTATIONS FOR UEFI-GRUB IN user-data FILE"
#TODO: /bin/bash config-uefi_grub_user-data.sh


printAndLogEndMessage "FINISH: INSTALLATION OF TFTP - SERVER"

 
