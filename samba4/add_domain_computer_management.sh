#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


printAndLogMessage "CREATE CONTAINER FOR MANAGER GROUPS/USERS ${OU_MANAGER_CONTAINER}"
createSambaOUpath ${OU_MANAGER_CONTAINER}

printAndLogMessage "CREATE CONTAINER FOR DOMAIN COMPUTERS ${OU_DOMAIN_COMPUTERS_CONTAINER}"
createSambaOUpath ${OU_DOMAIN_COMPUTERS_CONTAINER}

printAndLogMessage "CREATE CONTAINER FOR DOMAIN SERVERS ${OU_DOMAIN_SERVERS_CONTAINER}"
createSambaOUpath ${OU_DOMAIN_SERVERS_CONTAINER}

printAndLogMessage "CREATE COMPUTER DOMAIN JOIN GROUP ${DOMAIN_JOIN_GROUP}"
samba-tool group add ${DOMAIN_JOIN_GROUP}

printAndLogMessage "move ${DOMAIN_JOIN_GROUP} to ${OU_MANAGER_CONTAINER}"
samba-tool group move ${DOMAIN_JOIN_GROUP} ${OU_MANAGER_CONTAINER}

printAndLogMessage "ADD ACCLS TO ${OU_DOMAIN_COMPUTERS_CONTAINER} FOR ${DOMAIN_JOIN_GROUP}"
OBJECT_SID_LONG=$(samba-tool group show ${DOMAIN_JOIN_GROUP} --attributes=objectSid)
## we get something like this:
## dn: CN=domain_join_group,OU=701036,DC=brg,DC=tsn
## objectSid: S-1-5-21-1101371487-3695870978-1069032044-1103
## we extract SID, which is last word of the string
OBJECT_SID=$(echo ${OBJECT_SID_LONG} | awk '{print $NF}')
## we build SDDL String
SDDL="(${JOIN_ACCESS_FLAG};${JOIN_INHERIT_FLAG};${JOIN_ACL_LIST};;;${OBJECT_SID})"
printAndLogMessage "SDDL ${SDDL} added to object ${OU_DOMAIN_COMPUTERS_CONTAINER}"
## we need DN for ${OU_TSN_SYNC_CONTAINER} :-(
samba-tool dsacl set --objectdn="${OU_DOMAIN_COMPUTERS_CONTAINER},${SAMBA4_ROOT_DN}" --sddl=${SDDL}

printAndLogMessage "CREATE DOMAIN-JOIN-USER ${DOMAIN_JOIN_USER}"
samba-tool user create ${DOMAIN_JOIN_USER} ${DOMAIN_JOIN_USER_PASSWORD}

printAndLogMessage "add ${DOMAIN_JOIN_USER} to ${DOMAIN_JOIN_GROUP}"
samba-tool group addmembers ${DOMAIN_JOIN_GROUP} ${DOMAIN_JOIN_USER}

printAndLogMessage "move ${DOMAIN_JOIN_USER} to ${OU_MANAGER_CONTAINER}"
samba-tool user move ${DOMAIN_JOIN_USER} ${OU_MANAGER_CONTAINER}

