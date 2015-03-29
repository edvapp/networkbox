#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# install NFS - Server
restoreOriginal /etc/exports

apt-get -y purge nfs-kernel-server

rmdir -p $NFS_EXPORT_DIR


