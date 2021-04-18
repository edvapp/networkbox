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
${SAMBA4_NFS_TEACHERS_HOMEDIR}   ${NFS_EXPORT_TEACHERS_HOMEDIR}         none    bind  0  0
#
${SAMBA4_NFS_PUPILS_HOMEDIR}     ${NFS_EXPORT_PUPILS_HOMEDIR}           none    bind  0  0
#
${SAMBA4_NFS_STAFF_HOMEDIR}      ${NFS_EXPORT_STAFF_HOMEDIR}            none    bind  0  0
#
" >> $file

logFile $file

