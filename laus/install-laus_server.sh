#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# create LAUS - autoinstall - directory

printAndLogStartMessage "START: INSTALLATION OF LAUS - SERVER"

CURRENTRIR=$(pwd)
printAndLogMessage "clone git repository https://github.com/edvapp/autoinstall.git to /opt"
cd /opt
git clone https://github.com/edvapp/autoinstall.git
cd ${CURRENTRIR};
printAndLogMessage "Create export directory"
mkdir -p $NFS_EXPORT_DIR/autoinstall

mount --bind /opt/autoinstall $NFS_EXPORT_DIR/autoinstall

printAndLogMessage "MOUNT /opt/autoinstall TO EXPORTS DIRECTORY $NFS_EXPORT_DIR/autoinstall"
/bin/bash change-etc_fstab.sh

printAndLogMessage "ADD $NFS_EXPORT_DIR/autoinstall TO /etc/exports"
/bin/bash change-etc_exports.sh

printAndLogMessage "ADD hostsToClasses TO /opt/autoinstall/laus"
/bin/bash create-opt_autoinstall_laus_hostsToClasses.sh

printAndLogMessage "CREATE CLASS NEWWORKBOX FOR STARTUP"
/bin/bash create-classNETWORKBOX.sh

service nfs-kernel-server restart

printAndLogEndMessage "FINISH: INSTALLATION OF LAUS - SERVER"


