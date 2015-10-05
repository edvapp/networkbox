#! /bin/bash

# source /etc/default/
. /etc/default/tftpd-hpa
# to get variable $TFTP_DIRECTORY
# configured in /etc/default/tftpd-hpa


FILELIST="initrd.gz linux pxelinux.0"

# download 14.04 i386
SOURCE="http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-i386/current/images/netboot/ubuntu-installer/i386/"
DEST=$TFTP_DIRECTORY"/ubuntu-installer/14.04/i386/"

for FILE in $FILELIST;
do
	if [ ! -e ${DEST}${FILE} ];
	then
		wget -P $DEST ${SOURCE}${FILE}
	fi
done

# download 14.04 amd64
SOURCE="http://archive.ubuntu.com/ubuntu/dists/trusty/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/"
DEST=$TFTP_DIRECTORY"/ubuntu-installer/14.04/amd64/"

for FILE in $FILELIST;
do
	if [ ! -e ${DEST}${FILE} ];
	then
		wget -P $DEST ${SOURCE}${FILE}
	fi
done

# copy pxelinux.0 to top - directory
cp $TFTP_DIRECTORY"/ubuntu-installer/14.04/i386/pxelinux.0" $TFTP_DIRECTORY


# download 15.04 i386
SOURCE="http://archive.ubuntu.com/ubuntu/dists/vivid/main/installer-i386/current/images/netboot/ubuntu-installer/i386/"
DEST=$TFTP_DIRECTORY"/ubuntu-installer/15.04/i386/"

for FILE in $FILELIST;
do
	if [ ! -e ${DEST}${FILE} ];
	then
		wget -P $DEST ${SOURCE}${FILE}
	fi
done

# download 15.04 amd64
SOURCE="http://archive.ubuntu.com/ubuntu/dists/vivid/main/installer-amd64/current/images/netboot/ubuntu-installer/amd64/"
DEST=$TFTP_DIRECTORY"/ubuntu-installer/15.04/amd64/"

for FILE in $FILELIST;
do
	if [ ! -e ${DEST}${FILE} ];
	then
		wget -P $DEST ${SOURCE}${FILE}
	fi
done


