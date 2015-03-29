#!/bin/bash

# uninstall LAUS - Server

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

service nfs-kernel-server stop

umount $NFS_EXPORT_DIR/autoinstall

# manipulated file
file=/etc/fstab

sed -e "{
/\/opt\/autoinstall/d
}" -i $file

# manipulated file
file=/etc/exports

sed -e "{
/autoinstall/d
}" -i $file

service nfs-kernel-server start