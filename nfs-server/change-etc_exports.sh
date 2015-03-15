#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf


# For easier maintenance we will isolate all NFS exports in single directory, 
# where the real directories will be mounted with the --bind option. 

# manipulated file
file=/etc/exports

# save original
saveOriginal $file

getCIDRsubnetmask $NFS_NETWORK

echo "
$NFS_EXPORT_DIR      	$NFS_NETWORK/$CIDR_SUBNETMASK(rw,fsid=0,insecure,no_subtree_check,async)
" 
>> $file
