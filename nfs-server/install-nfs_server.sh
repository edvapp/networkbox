#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

printAndLogStartMessage "START: INSTALLATION OF NFS - SERVER"

printAndLogMessage "check in /etc/exports, if filesystem is already exported"
if [ -f /etc/exports -a "$(grep -e $NFS_EXPORT_DIR /etc/exports)"=="$NFS_EXPORT_DIR" ];
then
	printAndLogMessage "filesystem already exported"
	exit
fi

printAndLogMessage "install NFS - Server"
# HOWTO from https://help.ubuntu.com/community/SettingUpNFSHowTo
if [ ! "$FULLINSTALL" = "true" ];
then
	echo "FULLINSTALL=false"
	apt-get -y update
fi

printAndLogMessage "apt-get -y install nfs-kernel-server"
apt-get -y install nfs-kernel-server

printAndLogMessage "Create export directory " $NFS_EXPORT_DIR
mkdir -p $NFS_EXPORT_DIR

printAndLogMessage "WRITE TO /ETC/EXPORTS"
/bin/bash change-etc_exports.sh

service nfs-kernel-server restart

printAndLogEndMessage "FINISH: INSTALLATION OF NFS - SERVER"
