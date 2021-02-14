#! /bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa


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

