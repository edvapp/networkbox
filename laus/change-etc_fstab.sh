#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# manipulated file
file=/etc/fstab

# save original.conf.options
saveOriginal $file

echo "
#
/opt/autoinstall   $NFS_EXPORT_DIR/autoinstall   none    bind  0  0
#
" >> $file
