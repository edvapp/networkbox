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
${SAMBA4_HOMES_BASE_DIR}/users/   $NFS_EXPORT_DIR/users   none    bind  0  0
#
" >> $file

logFile $file
