#! /bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa


printAndLogMessage "### Download for BIOS/Legacy Boot ###"
FILELIST="initrd.gz linux pxelinux.0"


printAndLogMessage "Download 18.04 amd64"
SOURCE="http://archive.ubuntu.com/ubuntu/dists/bionic/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/"
DEST=$TFTP_DIRECTORY"/ubuntu-installer/18.04/amd64/"

for FILE in $FILELIST;
do
	if [ ! -e ${DEST}${FILE} ];
	then
		printAndLogMessage "wget -P "$DEST ${SOURCE}${FILE}
		wget -P $DEST ${SOURCE}${FILE}
	fi
done


printAndLogMessage "Download 20.04 amd64"
# SOURCE="http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/"
SOURCE="http://archive.ubuntu.com/ubuntu/dists/focal/main/installer-amd64/current/legacy-images/netboot/ubuntu-installer/amd64/"
DEST=$TFTP_DIRECTORY"/ubuntu-installer/20.04/amd64/"

for FILE in $FILELIST;
do
	if [ ! -e ${DEST}${FILE} ];
	then
		printAndLogMessage "wget -P "$DEST ${SOURCE}${FILE}
		wget -P $DEST ${SOURCE}${FILE}
	fi
done


printAndLogMessage "copy pxelinux.0 to top - directory"
cp $TFTP_DIRECTORY"/ubuntu-installer/20.04/amd64/pxelinux.0" $TFTP_DIRECTORY

printAndLogMessage "copy ldlinux.c32 to top - directory"
cp $TFTP_DIRECTORY"/ubuntu-installer/menus/boot-screens/ldlinux.c32" $TFTP_DIRECTORY



printAndLogMessage "### Download for UEFI Boot ###"
# we just need grubnetx64.efi, but we download grubx64.efi as well
# we download the signed parts as well
FILELIST="grubx64.efi grubnetx64.efi grubx64.efi.signed grubnetx64.efi.signed"


printAndLogMessage "Download 20.04 amd64"
# SOURCE="http://archive.ubuntu.com/ubuntu/dists/focal/main/uefi/grub2-amd64/current/"
SOURCE="http://archive.ubuntu.com/ubuntu/dists/focal/main/uefi/grub2-amd64/current/"
DEST=$TFTP_DIRECTORY"/"

for FILE in $FILELIST;
do
	if [ ! -e ${DEST}${FILE} ];
	then
		printAndLogMessage "wget -P "$DEST ${SOURCE}${FILE}
		wget -P $DEST ${SOURCE}${FILE}
	fi
done

