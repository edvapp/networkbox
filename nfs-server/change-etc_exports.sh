#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


# For easier maintenance we will isolate all NFS exports in single directory, 
# where the real directories will be mounted with the --bind option. 

# manipulated file
file=/etc/exports
printAndLogMessage "Manipulated file: " $file

# save original
printAndLogMessage "Save original file: " $file
saveOriginal $file
logFile $file

printAndLogMessage "write root export to: " $file
getCIDRsubnetmask $NETMASK

echo "
$NFS_EXPORT_DIR      	$NETWORK/$CIDR_SUBNETMASK(fsid=0,rw,insecure,no_subtree_check,async)
" >> $file

logFile $file