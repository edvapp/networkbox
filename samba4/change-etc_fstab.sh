#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/fstab
printAndLogMessage "Manipulated file: " $file

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Write to file: " $file
echo "
#
${SAMBA4_HOMES_BASE_DIR}/l   $NFS_EXPORT_DIR/l   none    bind  0  0
#
${SAMBA4_HOMES_BASE_DIR}/s   $NFS_EXPORT_DIR/s   none    bind  0  0
#
${SAMBA4_HOMES_BASE_DIR}/v   $NFS_EXPORT_DIR/v   none    bind  0  0
#
" >> $file

logFile $file
