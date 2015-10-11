#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# create LAUS - autoinstall - directory

CURRENTRIR=$(pwd)
cd /opt
git clone https://github.com/edvapp/autoinstall.git
cd ${CURRENTRIR};
# create export directory
mkdir -p $NFS_EXPORT_DIR/autoinstall

mount --bind /opt/autoinstall $NFS_EXPORT_DIR/autoinstall

# mount /opt/autoinstall to export directory /export/autoinstall
/bin/bash change-etc_fstab.sh

# add /export/autoinstall to exports
/bin/bash change-etc_exports.sh

# add hostsToClasses to /opt/autoinstall/laus
/bin/bash create-opt_autoinstall_laus_hostsToClasses.sh

# create class NEWWORKBOX for startup
/bin/bash create-classNETWORKBOX.sh

service nfs-kernel-server restart


