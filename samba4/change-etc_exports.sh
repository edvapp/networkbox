#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/exports
printAndLogMessage "Manipulated file: " $file

printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "Write to file: " $file

getCIDRsubnetmask $NETMASK

echo "

$NFS_EXPORT_DIR/users	$NETWORK/$CIDR_SUBNETMASK(rw,nohide,insecure,no_subtree_check,async)

" >> $file

logFile $file
