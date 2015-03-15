#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


# check in /etc/exports,
# if filesystem is already exported
if [ $(grep -c -e "fsid=0" install-nfs_server.sh) == "1" ];
then
	exit
fi

# install NFS - Server
# HOWTO from https://help.ubuntu.com/community/SettingUpNFSHowTo
apt-get -y update
apt-get -y install nfs-kernel-server

# create export directory
mkdir -p $NFS_EXPORT_DIR

/bin/bash change-etc_exports.sh

service nfs-kernel-server restart

