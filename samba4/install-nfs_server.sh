#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../SAMBA4.conf

printAndLogStartMessage "START: INSTALLATION OF NFS - SERVER"

printAndLogMessage "check in /etc/exports, if filesystem is already exported"
if [ -f /etc/exports -a "$(grep -e ${SAMBA4_NFS_EXPORT_DIR} /etc/exports)"=="${SAMBA4_NFS_EXPORT_DIR}" ];
then
	printAndLogMessage "filesystem already exported"
	exit
fi

printAndLogMessage "Install NFS - Server"
# HOWTO from https://help.ubuntu.com/community/SettingUpNFSHowTo
printAndLogMessage "apt-get -y install nfs-kernel-server"
apt-get -y install nfs-kernel-server

printAndLogMessage "Create export directory with subdirectories" ${SAMBA4_NFS_EXPORT_DIR}
for CONTAINER in ${OU_TSN_SYNC_CONTAINER_LIST};
do
        # we drop OU= from container: OU=701036 -> 701036
        SCHOOL_IDENTIFIER=${CONTAINER#OU=}        
        for GROUP_IDENTIFIER in ${GROUP_IDENTIFIER_LIST};
        do
                mkdir -v -p ${SAMBA4_NFS_EXPORT_DIR}/${SCHOOL_IDENTIFIER}/${GROUP_IDENTIFIER} 
        done
done

printAndLogMessage "MOUNT BIND ${SAMBA4_HOMES_BASE_DIR}/... TO EXPORTS DIRECTORY ${NFS_EXPORT_DIR}/..."
/bin/bash change-etc_fstab.sh

printAndLogMessage "ADD ${NFS_EXPORT_DIR}/... TO /etc/exports"
/bin/bash change-etc_exports.sh

if [ "${KERBEROS_SECURITY}" != "" ];
then
        printAndLogMessage "ACTIVATE GSS DAAEMON"
        /bin/bash change-etc_default_nfs-kernel-server.sh
        
        printAndLogMessage "ACTIVATE IDMAP DAAEMON"
        /bin/bash change-etc_default_nfs-common.sh

fi

systemctl restart nfs-kernel-server

printAndLogEndMessage "FINISH: INSTALLATION OF NFS - SERVER"


