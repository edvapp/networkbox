#!/bin/bash

# create LAUS - autoinstall - directory
cd /opt
git clone http://github.com/edvapp/autoinstall.git

# create NFS4 export
# install NFS - Server
# from https://help.ubuntu.com/community/SettingUpNFSHowTo
apt-get -y update
apt-get -y install nfs-kernel-server

# create export directory
mkdir -p /export/autoinstall

# mount /opt/autoinstall to export directory /export/autoinstall
/bin/bash change-etc_fstab.sh

# add /export/autoinstall to exports
/bin/bash change-etc_exports.sh

