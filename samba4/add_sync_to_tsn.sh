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
samba-tool group add ${TSN_SYNC_GROUP} --gid-number=${TSN_SYNC_GROUP_GID_NUMBER} --nis-domain=${SAMBA4_DOMAIN}

printAndLogMessage "move ${TSN_SYNC_GROUP} to ${OU_TSN_SYNC_CONTAINER}"
samba-tool group move ${TSN_SYNC_GROUP} ${OU_TSN_SYNC_CONTAINER}

printAndLogMessage "ADD ACCLS TO ${OU_TSN_SYNC_CONTAINER} FOR ${TSN_SYNC_GROUP}"
OBJECT_SID_LONG=$(samba-tool group show ${TSN_SYNC_GROUP} --attributes=objectSid)
## we get something like this:
## dn: CN=TSN_sync_group,OU=701036,DC=brg,DC=tsn
## objectSid: S-1-5-21-1101371487-3695870978-1069032044-1103
## we extract SID, which is last word of the string
OBJECT_SID=$(echo ${OBJECT_SID_LONG} | awk '{print $NF}')
## we build SDDL String
SDDL="(${ACCESS_FLAG};${INHERIT_FLAG};${ACL_LIST};;;${OBJECT_SID})"
printAndLogMessage "SDDL ${SDDL} added to object ${OU_TSN_SYNC_CONTAINER}"
## we need DN for ${OU_TSN_SYNC_CONTAINER} :-(
samba-tool dsacl set --objectdn="${OU_TSN_SYNC_CONTAINER},${SAMBA4_ROOT_DN}" --sddl=${SDDL}

printAndLogMessage "CREATE TSN-SYNC-USER ${TSN_SYNC_USER}"
samba-tool user create ${TSN_SYNC_USER} ${TSN_SYNC_USER_PASSWORD} --uid-number=${TSN_SYNC_USER_UID_NUMBER} --gid-number=${TSN_SYNC_USER_GID_NUMBER}

printAndLogMessage "add ${TSN_SYNC_USER} to ${TSN_SYNC_GROUP}"
samba-tool group addmembers ${TSN_SYNC_GROUP} ${TSN_SYNC_USER}

printAndLogMessage "move ${TSN_SYNC_USER} to ${OU_TSN_SYNC_CONTAINER}"
samba-tool user move ${TSN_SYNC_USER} ${OU_TSN_SYNC_CONTAINER}

