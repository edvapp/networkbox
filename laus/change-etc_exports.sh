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

/export       		$LAUS_NETWORK/24(rw,fsid=0,insecure,no_subtree_check,async)
/export/autoinstall	$LAUS_NETWORK/24(rw,nohide,insecure,no_subtree_check,async)

" >> $file