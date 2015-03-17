#!/bin/bash

# uninstall LAUS - Server
exit
restoreOriginal /etc/exports

restoreOriginal /etc/fstab

apt-get -y purge nfs-kernel-server
