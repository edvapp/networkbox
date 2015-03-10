#! /bin/bash

FILELIST="initrd.gz linux pxelinux.0"

# download 14.04 i386
SOURCE="http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-i386/current/images/netboot/ubuntu-installer/i386/"
DEST="ubuntu-installer/14.04/i386/"

for FILE in $FILELIST;
do
	if [ ! -e ${DEST}${FILE} ];
	then
		wget -P $DEST ${SOURCE}${FILE}
	fi
done

# download 14.04 amd64
SOURCE="http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/"
DEST="ubuntu-installer/14.04/amd64/"

for FILE in $FILELIST;
do
	if [ ! -e ${DEST}${FILE} ];
	then
		wget -P $DEST ${SOURCE}${FILE}
	fi
done

# copy pxelinux.0 to top - directory
cp ubuntu-installer/14.04/i386/pxelinux.0 pxelinux.0

