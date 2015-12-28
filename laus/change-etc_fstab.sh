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
/opt/autoinstall   $NFS_EXPORT_DIR/autoinstall   none    bind  0  0
#
" >> $file

logFile $file