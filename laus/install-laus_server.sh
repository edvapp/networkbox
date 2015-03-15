#!

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# create LAUS - autoinstall - directory

CURRENTRIR=$(pwd)
cd /opt
git clone http://github.com/edvapp/autoinstall.git
cd ${CURRENTRIR};

# create export directory
mkdir -p $NFS_EXPORT_DIR/autoinstall

# mount /opt/autoinstall to export directory /export/autoinstall
/bin/bash change-etc_fstab.sh

# add /export/autoinstall to exports
/bin/bash change-etc_exports.sh

service nfs-kernel-server restart


