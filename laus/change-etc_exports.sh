#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/exports

# save original
saveOriginal $file

getCIDRsubnetmask $NFS_NETMASK

echo "

$NFS_EXPORT_DIR/autoinstall	$NFS_NETWORK/$CIDR_SUBNETMASK(rw,nohide,insecure,no_subtree_check,async)

" >> $file