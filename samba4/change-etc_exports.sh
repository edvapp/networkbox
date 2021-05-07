#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/exports
printAndLogMessage "Manipulated file: " ${file}

printAndLogMessage "Save original file: " ${file}
saveOriginal $file
logFile $file

printAndLogMessage "Write to file: " ${file}

getCIDRsubnetmask $NETMASK

if [ "${KERBEROS_SECURITY}" != "" ];
then
        ## we add semicolon "," to krb5 opttion if not empty to add to export options
        KRB5="${KERBEROS_SECURITY},"
fi


echo "
${NFS_EXPORT_DIR} ${NETWORK}/${CIDR_SUBNETMASK}(${KRB5}fsid=0,rw,insecure,no_subtree_check,async)
#
#" >> ${file}

for CONTAINER in ${OU_TSN_SYNC_CONTAINER_LIST};
do
        echo "# adding exports for ${CONTAINER}" >> $file
        # we drop OU= from container: OU=701036 -> 701036
        SCHOOL_IDENTIFIER=${CONTAINER#OU=}        
        for GROUP_IDENTIFIER in ${GROUP_IDENTIFIER_LIST};
        do
                echo "#"
                echo "${NFS_EXPORT_DIR}/${SCHOOL_IDENTIFIER}/${GROUP_IDENTIFIER} \
                      ${NETWORK}/${CIDR_SUBNETMASK}(${KRB5}rw,nohide,insecure,no_subtree_check,async)" >> ${file}
        done
done

echo "#
" >> ${file}

logFile $file


