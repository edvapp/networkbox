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

printAndLogMessage "CREATE TSN-SYNC-CONTAINER ${TSN_SYNC_CONTAINER}"
samba-tool ou create ${TSN_SYNC_CONTAINER}

printAndLogMessage "CREATE TSN-SYNC-GROUP ${TSN_SYNC_GROUP}"
samba-tool group add ${TSN_SYNC_GROUP} --gid-number==${TSN_SYNC_GROUP_GID_NUMBER}

printAndLogMessage "move ${TSN_SYNC_GROUP} to ${TSN_SYNC_CONTAINER}"
samba-tool group move ${TSN_SYNC_GROUP} ${TSN_SYNC_CONTAINER}

printAndLogMessage "ADD ACCLS TO ${TSN_SYNC_CONTAINER} FOR ${TSN_SYNC_GROUP}"
## we get full DN= ...
OBJECT_SID_LONG=$(samba-tool group show ${TSN_SYNC_GROUP} --attributes=objectSid)
## we extract SID, which is last word of the dstring
OBJECT_SID=$(echo ${OBJECT_SID_LONG} | awk '{print $NF}')
## we build SDDL String
SDDL="(A;;${ACL_LIST};;;${OBJECT_SID})"
printAndLogMessage "SDDL ${SDDL} added to object ${TSN_SYNC_CONTAINER}"
samba-tool dsacl set --objectdn=OU=${TSN_SYNC_CONTAINER} --sddl=${SDDL}

printAndLogMessage "CREATE TSN-SYNC-USER ${TSN_SYNC_USER}"
samba-tool group create ${TSN_SYNC_USER} --uid-number=${TSN_SYNC_USER_UID_NUMBER} --gid-number==${TSN_SYNC_USER_GID_NUMBER}

printAndLogMessage "add ${TSN_SYNC_USER} to ${TSN_SYNC_GROUP}"
samba-tool group addmembers ${TSN_SYNC_GROUP} ${TSN_SYNC_USER}

printAndLogMessage "move ${TSN_SYNC_USER} to ${TSN_SYNC_CONTAINER}"
samba-tool user move ${TSN_SYNC_USER} ${TSN_SYNC_CONTAINER}

