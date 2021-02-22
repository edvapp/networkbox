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

##############################################################################################
#### CONFIGURATION FOR ***LEGACY-PXE-PART*** ON TFTP - SERVER ################################
printAndLogMessage "CONFIGURATION FOR ***LEGACY-PXE-PART*** ON TFTP - SERVER"

## 1: we copy all the needed files for tftp
printAndLogMessage "cp -R pxelinux.cfg ${TFTP_DIRECTORY}"
printAndLogMessage "cp -R ubuntu-installer ${TFTP_DIRECTORY}"
printAndLogMessage "cp -R preseed ${TFTP_DIRECTORY}"
cp -R pxelinux.cfg 	${TFTP_DIRECTORY}
cp -R ubuntu-installer	${TFTP_DIRECTORY}
cp -R preseed		${TFTP_DIRECTORY}

## 2: we set a password for bootmenues
printAndLogMessage "SET PASSWORD FOR TFTP-LEGACY-PXE-BOOT-SCREEN"
/bin/bash legacy_pxe-set_password_for_bootmenu.sh

## 3: we set the tftp-hostname where necessary
printAndLogMessage "SET TFTP-Servername IN LEGACY-PXE-PRESEED - FILES AND LEGACY-PXE-BOOTSCREENS MENU.CFG"
/bin/bash legacy_pxe-set_tftpservername.sh

## 4: we download all necessary files for pxe - boot
printAndLogMessage "DOWNLOAD UBUNTU - LEGACY-PXE-BOOT FILES and KERNEL IMAGES"
/bin/bash legacy_pxe-wget_ubuntustaff.sh

## 5: we config an admin-account
printAndLogMessage "SET ADMIN & ADMIN-PASSWORD FOR WORKSTATIONS IN LEGACY-PXE-PRESEED - FILES"
/bin/bash legacy_pxe-set_admin_account_in_preseed.sh

##############################################################################################
#### CONFIGURATION FOR ***UEFI-GRUB-SERVER_ISO-PART*** ON TFTP - SERVER ######################
printAndLogMessage "CONFIGURATION FOR ***UEFI-GRUB-SERVER_ISO-PART*** ON TFTP - SERVER"

## 1: we copy all the needed files for tftp
printAndLogMessage "COPY GRUB - CONFIGFILE to ${TFTP_DIRECTORY}/grub"
cp -R grub ${TFTP_DIRECTORY}

## 2: we set a password for bootmenues
## TODO:

## 3: we set the tftp-hostname where necessary
printAndLogMessage "SET TFTP-Servername IN GRUB - FILE"
/bin/bash uefi_grub-set_tftpservername.sh

## 4: we download all necessary files for uefi - boot
printAndLogMessage "DOWNLOAD UBUNTU - UEFI-GRUB-BOOT FILES"
/bin/bash uefi_grub-wget_ubuntustaff.sh

## 5: we install webserver to serve ubuntu-server-iso and yaml-configfiles
printAndLogMessage "INSTALL Apache - Webserver to serve ISO-image and YAML-configfiles"
printAndLogMessage "INSTALL p7zip-full to extract kernel and initrd from iso"
apt-get -y install apache2 p7zip-full

## 6: we download server-iso and extract kernel & initrd
printAndLogMessage "DOWNLOAD Ubuntu Server-ISO-IMAGE TO WEBSERVER_SUBDIRECTORY"
/bin/bash uefi_grub-wget_iso_and_extract_kernel_and_initrd.sh

## 7: we copy yaml - config -files to webserver
printAndLogMessage "COPY user-data & meta-data YAML FILES to WEBSERVER-SUBDIRECTORY"
mkdir ${HTTP_ISO_YAML_LAUS_DIR}/2P1F2F
cp ubuntu-server-installer/user-data_2P1F2F ${HTTP_ISO_YAML_LAUS_DIR}/2P1F2F/user-data
cp ubuntu-server-installer/meta-data ${HTTP_ISO_YAML_LAUS_DIR}/2P1F2F
mkdir ${HTTP_ISO_YAML_LAUS_DIR}/2P1F
cp ubuntu-server-installer/user-data_2P1F ${HTTP_ISO_YAML_LAUS_DIR}/2P1F/user-data
cp ubuntu-server-installer/meta-data ${HTTP_ISO_YAML_LAUS_DIR}/2P1F

## 8: we copy LAUS client files to webserver
cp ubuntu-server-installer/laus-client-files ${HTTP_ISO_YAML_LAUS_DIR}

## 9: we config an admin-account
printAndLogMessage "SET ADMIN & ADMIN-PASSWORD FOR WORKSTATIONS FOR UEFI-GRUB IN user-data FILE"
/bin/bash uefi_grub-set_admin_account_in_user-data.sh

printAndLogEndMessage "FINISH: INSTALLATION OF TFTP - SERVER"

 
