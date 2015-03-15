#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/exports

# save original
saveOriginal $file

echo "

$NFS_EXPORT_DIR/autoinstall	$LAUS_NETWORK/$CIDR_NETMASK(rw,nohide,insecure,no_subtree_check,async)

" 
#>> $file