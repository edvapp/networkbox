#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


if [ ! ${ENABLE_TSN_SYNCRONISATION} == "yes" ];
then
        printAndLogMessage "TSN SYCRONISATION will NOT be enabled"
        exit
fi

printAndLogMessage "CREATE TSN-SYNC-CONTAINER ${OU_TSN_SYNC_CONTAINER}"
samba-tool ou create ${OU_TSN_SYNC_CONTAINER}

printAndLogMessage "CREATE TSN-SYNC-GROUP ${TSN_SYNC_GROUP}"
samba-tool group add ${TSN_SYNC_GROUP}

printAndLogMessage "move ${TSN_SYNC_GROUP} to ${OU_MANAGER_CONTAINER}"
samba-tool group move ${TSN_SYNC_GROUP} ${OU_MANAGER_CONTAINER}

printAndLogMessage "ADD ACCLS TO ${OU_TSN_SYNC_CONTAINER} FOR ${TSN_SYNC_GROUP}"
OBJECT_SID_LONG=$(samba-tool group show ${TSN_SYNC_GROUP} --attributes=objectSid)
## we get something like this:
## dn: CN=TSN_sync_group,OU=701036,DC=brg,DC=tsn
## objectSid: S-1-5-21-1101371487-3695870978-1069032044-1103
## we extract SID, which is last word of the string
OBJECT_SID=$(echo ${OBJECT_SID_LONG} | awk '{print $NF}')
## we build SDDL String
SDDL="(${SYNC_ACCESS_FLAG};${SYNC_INHERIT_FLAG};${SYNC_ACL_LIST};;;${OBJECT_SID})"
printAndLogMessage "SDDL ${SDDL} added to object ${OU_TSN_SYNC_CONTAINER}"
## we need DN for ${OU_TSN_SYNC_CONTAINER} :-(
samba-tool dsacl set --objectdn="${OU_TSN_SYNC_CONTAINER},${SAMBA4_ROOT_DN}" --sddl=${SDDL}

printAndLogMessage "CREATE TSN-SYNC-USER ${TSN_SYNC_USER}"
samba-tool user create ${TSN_SYNC_USER} ${TSN_SYNC_USER_PASSWORD}

printAndLogMessage "add ${TSN_SYNC_USER} to ${TSN_SYNC_GROUP}"
samba-tool group addmembers ${TSN_SYNC_GROUP} ${TSN_SYNC_USER}

printAndLogMessage "move ${TSN_SYNC_USER} to ${OU_MANAGER_CONTAINER}"
samba-tool user move ${TSN_SYNC_USER} ${OU_MANAGER_CONTAINER}

