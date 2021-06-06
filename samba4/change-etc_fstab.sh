#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../SAMBA4.conf

# manipulated file
file=/etc/fstab
printAndLogMessage "Manipulated file: " ${file}

printAndLogMessage "Save original file: " ${file}
saveOriginal ${file}
logFile ${file}

printAndLogMessage "Write to file: " ${file}

for CONTAINER in ${OU_TSN_SYNC_CONTAINER_LIST};
do
        echo "# adding exports for ${CONTAINER}" >> ${file}
        # we drop OU= from container: OU=701036 -> 701036
        SCHOOL_IDENTIFIER=${CONTAINER#OU=}
        for GROUP_IDENTIFIER in ${GROUP_IDENTIFIER_LIST};
        do
                echo "#"
                echo "${SAMBA4_HOMES_BASE_DIR}/${SCHOOL_IDENTIFIER}/${GROUP_IDENTIFIER} \
                       ${NFS_EXPORT_DIR}/${SCHOOL_IDENTIFIER}/${GROUP_IDENTIFIER}     none    bind  0  0" >> ${file}
        done
done

echo "#
" >> ${file}

logFile ${file}


