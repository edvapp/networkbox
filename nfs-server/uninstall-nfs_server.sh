#!/bin/bash

# source helper functions
. ../helperfunctions.sh

# source configuration
. ../OPTIONS.conf

# install NFS - Server
apt-get -y purge nfs-kernel-server

restoreOriginal /etc/exports
