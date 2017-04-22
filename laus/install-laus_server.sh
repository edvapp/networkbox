#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# create LAUS - autoinstall - directory

printAndLogStartMessage "START: INSTALLATION OF LAUS - SERVER"

printAndLogMessage "CHECK IN /etc/exports, IF FILESYSTEM IS ALREADY EXPORTED"
if [ -f /etc/exports -a "$(grep -e $NFS_EXPORT_DIR /etc/exports)"=="$NFS_EXPORT_DIR" ];
then
	printAndLogMessage "FILESYSTEM ALREADY EXPORTED"
else
	printAndLogMessage "INSTALL NFS-SERVER FROM install-laus_server.sh"
	CURRENT_SUB_DIR=$(pwd)
	cd ../nfs-server
	/bin/bash install-nfs_server.sh
	cd ${CURRENT_SUB_DIR}
fi

CURRENT_SUB_DIR=$(pwd)
printAndLogMessage "clone git repository https://github.com/edvapp/autoinstall.git to /opt"
cd /opt
git clone https://github.com/edvapp/autoinstall.git
cd ${CURRENT_SUB_DIR}
printAndLogMessage "CREATE EXPORT DIRECTORY"
mkdir -p $NFS_EXPORT_DIR/autoinstall

mount --bind /opt/autoinstall $NFS_EXPORT_DIR/autoinstall

printAndLogMessage "MOUNT /opt/autoinstall TO EXPORTS DIRECTORY $NFS_EXPORT_DIR/autoinstall"
/bin/bash change-etc_fstab.sh

printAndLogMessage "ADD $NFS_EXPORT_DIR/autoinstall TO /etc/exports"
/bin/bash change-etc_exports.sh

printAndLogMessage "ADD hostsToClasses TO /opt/autoinstall/laus"
/bin/bash create-opt_autoinstall_laus_hostsToClasses.sh

printAndLogMessage "CREATE CLASS NETWORKBOX FOR STARTUP"
/bin/bash create-classNETWORKBOX.sh

service nfs-kernel-server restart

printAndLogEndMessage "FINISH: INSTALLATION OF LAUS - SERVER"


